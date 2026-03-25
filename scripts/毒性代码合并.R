# 1. 环境初始化
rm(list = ls()) 

# 加载必要的包
library(tidyverse)

# 2. 自动化读取与处理
data_path <- "data"

# --- 新增：定义并创建结果文件夹 ---
results_path <- "results"
if (!dir.exists(results_path)) {
  dir.create(results_path)
}

# 获取 data 文件夹下所有 CSV，并排除掉结果文件
all_files <- list.files(data_path, pattern = "\\.csv$", full.names = TRUE)
# 注意：现在结果不在 data 文件夹了，所以排除列表可以简化
exclude_files <- c("data/Toxicity_Files_List.csv", "data/test.csv")
files_to_read <- setdiff(all_files, exclude_files)

# 批量合并
combined_tox <- files_to_read %>%
  map_df(~ {
    df <- read_csv(.x, col_types = cols(.default = "c"), show_col_types = FALSE)
    
    # 提取毒性类型
    type_name <- basename(.x) %>% str_remove("\\.csv$") %>% str_split("_") %>% map_chr(1)
    df$Toxicity_Type <- type_name
    
    # 只筛选阳性数据
    if("Toxicity Value" %in% colnames(df)) {
      df <- df %>% filter(`Toxicity Value` == "1")
    }
    return(df)
  })

# 3. 数据聚合（按 TAID 分组）
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

# 4. 修改：保存结果到 results 文件夹
write_csv(tox_summary, file.path(results_path, "Combined_Toxicity_Data.csv"))

# 5. 输出统计
message("--- Process Finished ---")
message(paste("Results saved in:", results_path))
message(paste("Unique TAID Count:", nrow(tox_summary)))
message(paste("Multi-toxic Compounds:", sum(grepl("\\|", tox_summary$`Toxicity distribution`))))