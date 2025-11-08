import System.IO (
    IO, getLine, putStrLn, 
    IOMode(WriteMode), openFile, hClose, hSetEncoding, utf8, hPutStr
    )
import Data.List (intercalate)


-- 複数行入力を受け取る
getMultiLine :: IO String
getMultiLine = do
    line <- getLine
    if null line
        then return "" -- 空行なら入力を終了
        else do
            rest <- getMultiLine
            if null rest
                then return line
                else return (line ++ "\n" ++ rest)


main :: IO ()
main = do

    -- 入力
    putStrLn "① プロジェクトのタイトルを入力してください:"
    title <- getLine

    putStrLn "② キャプチャ画像のパス/URL (例: ./images/demo.gif) を入力してください (無ければEnter):"
    imagePath <- getLine

    putStrLn "③ 概要 (Markdown可 / 入力終了は「空行」):"
    overview <- getMultiLine

    putStrLn "④ デモ / 稼働URL を入力してください (無ければEnter):"
    demoUrl <- getLine

    putStrLn "⑤ 使用技術 (Markdown箇条書き推奨 / 入力終了は「空行」):"
    techStack <- getMultiLine

    putStrLn "⑥ 機能一覧 (Markdown箇条書き推奨 / 入力終了は「空行」):"
    features <- getMultiLine

    putStrLn "⑦ インストール / セットアップ手順 (Markdownコードブロック推奨 / 入力終了は「空行」):"
    installation <- getMultiLine

    putStrLn "⑧ 環境変数セクションを含めますか？ (.env.example への参照) (Y/N):"
    envChoice <- getLine

    putStrLn "⑨ ライセンス名 (例: MIT) を入力してください:"
    licenseName <- getLine

    putStrLn "⑩ 工夫した点 / 苦労した点 (Markdown可 / 入力終了は「空行」):"
    challenges <- getMultiLine


    -- 生成(let束縛で、入力された情報からMarkdown文字列を構築)
    let markdownContent = buildMarkdown title imagePath overview demoUrl techStack features installation envChoice licenseName challenges

    -- "README.md" に書き出し
    handle <- openFile "README.md" WriteMode
    hSetEncoding handle utf8
    hPutStr handle markdownContent
    hClose handle

    putStrLn "---"
    putStrLn "✅ README.md が正常に生成されました。"


-- 組み立て
buildMarkdown :: String -> String -> String -> String -> String -> String -> String -> String -> String -> String -> String
buildMarkdown title imagePath overview demoUrl techStack features installation envChoice licenseName challenges = "# " ++ title ++ "\n\n" ++

    -- ② 画像パスが入力された場合のみ、このセクションを生成
    (if not (null imagePath) then "## 🚀 キャプチャ / デモ\n\n" ++ "![" ++ title ++ "](" ++ imagePath ++ ")\n\n" else "") ++

    "## 概要\n\n" ++ overview ++ "\n\n" ++

    -- ④ デモURLが入力された場合のみ、このセクションを生成
    (if not (null demoUrl) then "## 🔗 デモ / 稼働URL\n\n" ++ demoUrl ++ "\n\n" else "") ++

    "## 🛠️ 使用技術\n\n" ++ techStack ++ "\n\n" ++

    "## ✨ 機能一覧\n\n" ++ features ++ "\n\n" ++

    "## 📦 インストール / セットアップ\n\n" ++ installation ++ "\n\n" ++

    -- ⑧ 環境変数でYと回答した場合のみ、このセクションを生成
    (if envChoice == "Y" || envChoice == "y"
        then "## 🔑 環境変数\n\n" ++ "必要な環境変数は `.env.example` を参照してください。\n\n"
        else "") ++

    "## 📜 ライセンス\n\n" ++
    "This project is licensed under the " ++ licenseName ++ " License.\n\n" ++

    "## 💡 工夫した点 / 苦労した点\n\n" ++ challenges ++ "\n"