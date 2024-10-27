cat("/014") # clear screen
# 0. Info ----

# Project: Learning Analysis
# Author: LiuZiyu 
# Created date: 2024/10
# Last edited date: 2024/10/19

# This script is for
# - 读取、描述和清洗 Moodle LMS 数据集
# - 建立分类模型

# Data source
# - 案例数据

#  ----
rm(list = ls())

library(tidyverse)
library(rio)
library(summarytools)
library(corrplot)
library(skimr)
library(knitr)

# 0 定义路径 ----
dir <- "D:/Library/OneDrive/0 Academic/5_Learning/2024-学习分析"
datadir <- file.path(dir, "example/data/1_moodleLAcourse")
outputdir <- file.path(dir, "data/1_moodleLAcourse")
setwd(datadir)

df_events <- import("Events.xlsx")
dfSummary(df_events)


df_demograph <- import("Demographics.xlsx")
df_results <- import("Results.xlsx")

df_merged <- df_events %>%
  full_join(df_demograph, by = "user") %>%
  full_join(df_results, by = "user")

skim(df_merged)

df_merged_long <- df_merged %>%
  pivot_longer(cols = starts_with("Grade.SNA"),
               names_to = "Grade",
               values_to = "SNA") %>%
  mutate(Grade = str_sub(Grade, -1))

df_merged_sum <- df_merged %>% 
  group_by(Gender) %>%
  count(Location)

df_merged_sum <- df_merged_sum[, c(1,3)]
chi_result <- chisq.test(df_merged_sum)
chi_sum <- report::report(chi_result)
table <- 

setwd(outputdir)
create_report(df_merged)
corrplot(cor(df_merged[, sapply(df_merged, is.numeric)]))
