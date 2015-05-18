module Main where

import Lambdabot.Pointful
import Pointfree

import Control.Monad.Trans (liftIO)
import GHCJS.DOM (webViewGetDomDocument, runWebGUI)
import GHCJS.DOM.Document (documentGetElementById)
import GHCJS.DOM.HTMLElement
import GHCJS.DOM.Element
import GHCJS.DOM.HTMLInputElement
import Data.List (intercalate)

main :: IO ()
main = runWebGUI $ \webView -> do
    Just doc         <- webViewGetDomDocument webView
    Just input       <- documentGetElementById doc "input"
    Just pointfreeEl <- documentGetElementById doc "pointfree"
    Just pointfulEl  <- documentGetElementById doc "pointful"

    let handler = liftIO $ do
            val <- htmlInputElementGetValue $ castToHTMLInputElement input
            htmlElementSetInnerHTML (castToHTMLElement pointfreeEl) $ intercalate "<br>" $ pointfree val
            htmlElementSetInnerHTML (castToHTMLElement pointfulEl) $ pointful val

    _ <- elementOnkeyup input $ handler
    _ <- elementOnkeydown input $ handler
    return ()
