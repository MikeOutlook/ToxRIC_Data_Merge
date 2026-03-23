rm(list = ls()) # 
setwd("E:\\11_AI drug\\TOXRIC") 
# 加载必要的包
library(dplyr)
library(readr)

# 读取所有数据集并添加毒性类型

car <- read_csv("Carcinogenicity_Carcinogenicity.csv")
car$Toxicity_Type <- "Carcinogenicity"
car <- car %>% filter(`Toxicity Value` == 1)

dev_tox <- read_csv("Developmental and Reproductive Toxicity_Developmental Toxicity.csv")
dev_tox$Toxicity_Type <- "Developmental"
dev_tox <- dev_tox %>% filter(`Toxicity Value` == 1)

rep_tox <- read_csv("Developmental and Reproductive Toxicity_Reproductive Toxicity.csv")
rep_tox$Toxicity_Type <- "Reproductive"
rep_tox <- rep_tox %>% filter(`Toxicity Value` == 1)

Carcinogenicity_Carcinogenicity <- read_csv("Carcinogenicity_Carcinogenicity.csv")
Carcinogenicity_Carcinogenicity$Toxicity_Type <- "Carcinogenicity"

Cardiotoxicity_Cardiotoxicity_1 <- read_csv("Cardiotoxicity_Cardiotoxicity-1.csv")
Cardiotoxicity_Cardiotoxicity_1$Toxicity_Type <- "Cardiotoxicity"

Cardiotoxicity_Cardiotoxicity_5 <- read_csv("Cardiotoxicity_Cardiotoxicity-5.csv")
Cardiotoxicity_Cardiotoxicity_5$Toxicity_Type <- "Cardiotoxicity"

Cardiotoxicity_Cardiotoxicity_10 <- read_csv("Cardiotoxicity_Cardiotoxicity-10.csv")
Cardiotoxicity_Cardiotoxicity_10$Toxicity_Type <- "Cardiotoxicity"

Cardiotoxicity_Cardiotoxicity_30 <- read_csv("Cardiotoxicity_Cardiotoxicity-30.csv")
Cardiotoxicity_Cardiotoxicity_30$Toxicity_Type <- "Cardiotoxicity"

Endocrine_Disruption_NR_AhR <- read_csv("Endocrine Disruption_NR-AhR.csv")
Endocrine_Disruption_NR_AhR$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_AR <- read_csv("Endocrine Disruption_NR-AR.csv")
Endocrine_Disruption_NR_AR$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_AR_LBD <- read_csv("Endocrine Disruption_NR-AR-LBD.csv")
Endocrine_Disruption_NR_AR_LBD$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_AR_aromatase <- read_csv("Endocrine Disruption_NR-aromatase.csv")
Endocrine_Disruption_NR_AR_aromatase$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_ER <- read_csv("Endocrine Disruption_NR-ER.csv")
Endocrine_Disruption_NR_ER$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_ER_LBD <- read_csv("Endocrine Disruption_NR-ER-LBD.csv")
Endocrine_Disruption_NR_ER_LBD$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_NR_PPAR_gamma <- read_csv("Endocrine Disruption_NR-PPAR-gamma.csv")
Endocrine_Disruption_NR_PPAR_gamma$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_SR_ARE <- read_csv("Endocrine Disruption_SR-ARE.csv")
Endocrine_Disruption_SR_ARE$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_SR_ATAD5 <- read_csv("Endocrine Disruption_SR-ATAD5.csv")
Endocrine_Disruption_SR_ATAD5$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_SR_HSE <- read_csv("Endocrine Disruption_SR-HSE.csv")
Endocrine_Disruption_SR_HSE$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_SR_MMP <- read_csv("Endocrine Disruption_SR-MMP.csv")
Endocrine_Disruption_SR_MMP$Toxicity_Type <- "Endocrine Disruption"

Endocrine_Disruption_SR_p53 <- read_csv("Endocrine Disruption_SR-p53.csv")
Endocrine_Disruption_SR_p53$Toxicity_Type <- "Endocrine Disruption"

Hepatotoxicity_Hepatotoxicity <- read_csv("Hepatotoxicity_Hepatotoxicity.csv")
Hepatotoxicity_Hepatotoxicity$Toxicity_Type <- "Hepatotoxicity"

Mutagenicity_Ames_Mutagenicity <- read_csv("Mutagenicity_Ames Mutagenicity.csv")
Mutagenicity_Ames_Mutagenicity$Toxicity_Type <- "Mutagenicity"

Respiratory_Toxicity_Respiratory_Toxicity <- read_csv("Respiratory Toxicity_Respiratory Toxicity.csv")
Respiratory_Toxicity_Respiratory_Toxicity$Toxicity_Type <- "Respiratory Toxicity"

# 合并所有数据集
combined_tox <- bind_rows(
  dev_tox, rep_tox, Carcinogenicity_Carcinogenicity,
  Cardiotoxicity_Cardiotoxicity_1, Cardiotoxicity_Cardiotoxicity_5, 
  Cardiotoxicity_Cardiotoxicity_10, Cardiotoxicity_Cardiotoxicity_30,
  Endocrine_Disruption_NR_AhR, Endocrine_Disruption_NR_AR,
  Endocrine_Disruption_NR_AR_LBD, Endocrine_Disruption_NR_AR_aromatase,
  Endocrine_Disruption_NR_ER, Endocrine_Disruption_NR_ER_LBD,
  Endocrine_Disruption_NR_PPAR_gamma, Endocrine_Disruption_SR_ARE,
  Endocrine_Disruption_SR_ATAD5, Endocrine_Disruption_SR_HSE,
  Endocrine_Disruption_SR_MMP, Endocrine_Disruption_SR_p53,
  Hepatotoxicity_Hepatotoxicity, Mutagenicity_Ames_Mutagenicity,
  Respiratory_Toxicity_Respiratory_Toxicity
)

# 移除Toxicity Value列（如果存在）
if("Toxicity Value" %in% colnames(combined_tox)) {
  combined_tox <- combined_tox %>% select(-`Toxicity Value`)
}

# 处理重复的TAID，创建毒性分布列
tox_summary <- combined_tox %>%
  group_by(TAID) %>%
  summarise(
    Name = first(na.omit(Name)),
    `IUPAC Name` = first(na.omit(`IUPAC Name`)),
    `PubChem CID` = first(na.omit(`PubChem CID`)),
    `Canonical SMILES` = first(na.omit(`Canonical SMILES`)),
    InChIKey = first(na.omit(InChIKey)),
    `Toxicity distribution` = paste(sort(unique(Toxicity_Type)), collapse = "|")
  ) %>%
  ungroup()

# 保存整理后的数据到新的CSV文件
write_csv(tox_summary, "Combined_Toxicity_Data.csv")

# 显示处理结果摘要
cat("数据处理完成！\n")
cat("合并后唯一TAID数量:", nrow(tox_summary), "\n")
cat("具有多重毒性的化合物数量:", sum(grepl("\\|", tox_summary$`Toxicity distribution`)), "\n")
cat("毒性类型分布:\n")
table(unlist(strsplit(tox_summary$`Toxicity distribution`, "\\|")))