# 1. 环境初始化
rm(list = ls()) 

# 加载必要的包
library(tidyverse)

# 2. 自动化读取与处理
# 使用相对路径，确保在任何电脑上只要在项目根目录下就能运行
data_path <- "data"

# 获取 data 文件夹下所有 CSV，并排除掉合并后的结果文件
all_files <- list.files(data_path, pattern = "\\.csv$", full.names = TRUE)
exclude_files <- c("data/Combined_Toxicity_Data.csv", "data/Toxicity_Files_List.csv", "data/test.csv")
files_to_read <- setdiff(all_files, exclude_files)

# 批量合并
combined_tox <- files_to_read %>%
  map_df(~ {
    # 读取数据，强制所有列为字符型防止合并冲突
    df <- read_csv(.x, col_types = cols(.default = "c"), show_col_types = FALSE)
    
    # 提取毒性类型：取文件名的第一部分（下划线前）
    type_name <- basename(.x) %>% str_remove("\\.csv$") %>% str_split("_") %>% map_chr(1)
    df$Toxicity_Type <- type_name
    
    # 只筛选阳性数据 (Toxicity Value == 1)
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
    # 生成毒性分布列
    `Toxicity distribution` = paste(sort(unique(Toxicity_Type)), collapse = "|")
  ) %>%
  ungroup()

# 4. 保存结果到 data 文件夹
write_csv(tox_summary, "data/Combined_Toxicity_Data.csv")

# 5. 输出统计（解决乱码建议用纯英文或确保编码正确）
message("--- Process Finished ---")
message(paste("Unique TAID Count:", nrow(tox_summary)))
message(paste("Multi-toxic Compounds:", sum(grepl("\\|", tox_summary$`Toxicity distribution`))))