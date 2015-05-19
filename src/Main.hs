{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lambdabot.Pointful
import Pointfree

import Control.Monad.Trans (liftIO)
import Data.Text (Text)
import qualified Data.Text as T

import GHCJS.DOM (webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (documentGetElementById)
import GHCJS.DOM.HTMLElement
import GHCJS.DOM.Element
import GHCJS.DOM.HTMLInputElement

main :: IO ()
main = runWebGUI $ \webView -> do
    Just doc         <- webViewGetDomDocument webView
    Just input       <- documentGetElementById doc ("input" :: Text)
    Just pointfreeEl <- documentGetElementById doc ("pointfree" :: Text)
    Just pointfulEl  <- documentGetElementById doc ("pointful" :: Text)

    let handler = liftIO $ do
            val <- htmlInputElementGetValue $ castToHTMLInputElement input
            htmlElementSetInnerHTML (castToHTMLElement pointfreeEl) $ evalPointfree val
            htmlElementSetInnerHTML (castToHTMLElement pointfulEl) $ evalPointful val

    _ <- elementOnkeyup input $ handler
    _ <- elementOnkeydown input $ handler
    return ()

evalPointfree :: String -> Text
evalPointfree = T.intercalate "<br>" . map (escape . T.pack) . pointfree

evalPointful :: String -> Text
evalPointful input = escape $ ignoreErrors $ T.pack $ pointful $ input
  where
    ignoreErrors output
      | any (`T.isPrefixOf` output) ["Error:", "<unknown>.hs"] = ""
      | ";" `T.isSuffixOf` output && not (";" `T.isSuffixOf` T.pack input) = T.init output
      | otherwise = output

escape :: Text -> Text
escape = T.replace "/" "&#x2F"
       . T.replace "'" "&#39;"
       . T.replace "\"" "&quot;"
       . T.replace ">" "&gt;"
       . T.replace "<" "&lt;"
       . T.replace "&" "&amp;"
