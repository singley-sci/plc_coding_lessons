# sample_code.R

# Use this file for sample code to help support analysis.


# LOAD PACKAGES ####

install.packages("tidyverse")
library(tidyverse)

install.packages("ggpubr")
library(ggpubr)

install.packages("Epi")
library(Epi)

install.packages("devtools")
devtools::install_github('smin95/smplot2', force = TRUE)
library(smplot2)


# LOAD DATA ####
data(births)
# loading the births data (part of the Epi package)
# take a look at the data by holding command while clicking "births" or use View(births_data)


# EXPLORE data ####
summary(births)
str(births)
names(births)
?births # explains where this dataset comes from and what each variable means (this command only works for datasets that are stored in R)


# CLEAN data ####
# Assure that the categorical variables are actually categorical
births <- births %>%
        dplyr::mutate(lowbw = as.factor(lowbw),
                      preterm = as.factor(preterm),
                      hyp = as.factor(hyp),
                      sex = as.factor(sex))
str(births) # check to see the class of variables after this cleaning step


# SUMMARIZE data ####
# Produce 6 number summary for a single variable
summary(births$hyp)


# FREQUENCY TABLES (1+ categorical vars) ####
# For categorical variables
# Use stat.table to make 2x2 tables
# Look at the number (count or frequency) of births by hypertension. 
# Can explore other variables by subbing them in instead of "hyp"
stat.table(list(hyp), data = births)
stat.table(list(hyp, lowbw), data = births)
stat.table(list(hyp, preterm), data = births)


# HISTOGRAMS (continuous vars) ####
# Used to check out the distribution of the continuous variables 

ggplot(births, aes(x = bweight)) + 
        geom_histogram(fill = "blue", color = "black") + 
        theme_bw() +
        xlab("Birth weight") +
        ylab("Frequency")

ggplot(births, aes(x = gestwks)) + 
        geom_histogram(fill = "purple", color = "black") + 
        theme_bw() +
        xlab("Gestation weeks") +
        ylab("Frequency")

ggplot(births, aes(x = matage)) + 
        geom_histogram(fill = "yellow", color = "black") + 
        theme_bw() +
        xlab("Maternal age") +
        ylab("Frequency")


# What if want to look at the HISTOGRAM of gestational age for mothers with and without hypertension?
hyp_names <- c(
        `0` = "Hypertension absent",
        `1` = "Hypertension present")
ggplot(births, aes(x = gestwks)) + 
        geom_histogram() + 
        facet_grid(~hyp, labeller = as_labeller(hyp_names)) + 
        theme_bw() +
        xlab("Gestation weeks at birth") +
        ylab("Frequency")


# BOXPLOTS (1 categorical var and 1 continuous var) ####
# What if you have a categorical variable in the x-axis (e.g., sex) and a continuous variable in the y-axis (bweight)?
ggplot(data = births,
       aes(x = sex,
           y = bweight, 
           group = sex)) +
        geom_boxplot() +
        theme_bw() +
        xlab("sex (1 = male; 2 = female)") +
        ylab("birthweight (g)") +
        stat_compare_means(method = "anova")


# SCATTER PLOTS (2 continuous variables) ####
#How about assessing relationships between continuous variables (scatter plots)
ggplot(data = births, aes(x = matage, y = bweight)) + 
        geom_point(aes(color = hyp)) +
        geom_smooth(aes(color = hyp)) +
        scale_color_discrete(name = 'Hypertension', 
                             labels = c("absent", "present")) +
        scale_fill_discrete(name = 'Hypertension', 
                            labels = c("absent", "present")) +
        theme_bw()

# Since these lines look mostly straight, let's get the pearson R-squared values for them (assumes linearity)
ggscatter(births, x = "matage", y = "bweight", color = "hyp",
          add = "reg.line", 
          conf.int = TRUE) +
        stat_cor(aes(color = hyp),
                 label.x = 23) +
        scale_color_discrete(name = 'Hypertension', 
                             labels = c("absent", "present")) +
        scale_fill_discrete(name = 'Hypertension', 
                            labels = c("absent", "present") 
        ) +
        theme_bw()


# LINEAR regression (continuous outcome var) ####

# Effect of maternal age on birth weight?
mod1 <- glm(bweight ~ matage, data = births, family = "gaussian")

summary(mod1)$coefficients
summary(mod1)$coefficients[2]
confint.default(mod1)[2, ]

# Effect of hypertension on birth weight?
mod2 <- glm(bweight ~ hyp, data = births, family = "gaussian")

summary(mod2)$coefficients
summary(mod2)$coefficients[2]
confint.default(mod2)[2, ]

# Consider the potential impact of the sex of the baby on the relationship between hypertension and birth weight?
mod_multi1 <- glm(bweight ~ hyp + sex, data = births, family = "gaussian")

summary(mod_multi1)$coefficients


# LOGISTIC regression (binary categorical outcome var) ####

# What if we wanted to examine the effect of hypertension on pre term birth, controlling for sex?
logistic_mod1 <- glm(preterm ~ hyp + sex, data = births, family = "binomial")

exp(coefficients(logistic_mod1)) # ORs
exp(confint.default(logistic_mod1)) # 95% CIs

exp(coefficients(logistic_mod1)[2]) # This is the Odds Ratio for effect of hypertension after controlling for sex.
exp(confint.default(logistic_mod1)[2, ]) # This is the 95% CI on the OR for effect of hypertension after controlling for sex.







