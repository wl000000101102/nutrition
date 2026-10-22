# 專案規範（nutrition）

這是公開的 GitHub 倉庫（GitHub Pages 部署）。任何協作者或 AI 工作階段都必須遵守：

## 絕對禁止提交到倉庫的內容
- 任何公司資訊：公司名稱、部門、同事姓名、公司信箱、內部網址／主機名稱／IP、內部文件。
- 任何個資：真實姓名、電話、電子郵件、住址、身分證件、個人照片（商品圖只能有商品本身）。
- 任何憑證：API key、token、密碼、私鑰、憑證檔、.env、雲端服務設定。
- 專案以外的任何資訊：與這個營養記錄 App 無關的檔案、截圖、筆記、聊天紀錄、工作階段連結。
- 使用者的個人健康資料：匯出的 JSON 備份、記錄截圖等不可放進倉庫。

## 提交前必做
- 執行 `bash scripts/check-leaks.sh`，必須顯示「未發現洩漏」才可以 commit。
- git 作者身分一律使用 GitHub noreply 信箱或 `Claude <noreply@anthropic.com>`，不可使用公司或個人信箱。
- commit 訊息只描述程式變更，不附工作階段連結或任何外部識別資訊（可保留 Co-Authored-By 行）。
- 嵌入的商品圖片必須先裁切去背、縮小並確認無 EXIF／位置資訊。

## 部署
- `main` 與 `gh-pages` 兩個分支內容必須一致，推送時兩邊都推。
- 每次推送 App 變更（index.html、sw.js、manifest、icons）前更新 `sw.js` 的 CACHE 版本與 `index.html` 的 APP_VER。
