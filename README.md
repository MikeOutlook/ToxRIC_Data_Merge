# ToxRIC Data Merge & Environment Management

[![R-Version](https://img.shields.io/badge/R-4.5.1-blue.svg)](https://www.r-project.org/)
[![Env-Management](https://img.shields.io/badge/Env-renv-orange.svg)](https://rstudio.github.io/renv/)

本仓库旨在自动化整合 ToxRIC 数据库中的多种毒性数据，并通过 `renv` 实现开发环境的可重复性。

## 📊 项目成果
- **数据总量**：成功合并 **10,106** 条唯一 TAID 化合物数据。
- **多重毒性**：识别出 **1,054** 个具有多重毒性分布的化合物。
- **自动化**：采用动态扫描 `data/` 文件夹的逻辑，支持一键合并新增 CSV 文件。

## 🛠️ 环境恢复指南 (Reproducibility)

本项目使用 `renv` 管理 R 包依赖。为了在您的电脑上完美运行此项目，请按以下步骤操作：

1. **克隆项目**：
   ```bash
   git clone git@github.com:MikeOutlook/ToxRIC_Data_Merge.git
   cd ToxRIC_Data_Merge