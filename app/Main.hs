{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)

import Data.Aeson
import Data.Text
import Data.Proxy
import Control.Monad.Trans.Either

import Servant
import Servant.Server

import Lib

-- Types
data Hello = Hello

-- Serialization
instance ToJSON Hello where
  toJSON = const $ object [ "message" .= ("hello world" :: Text) ]

-- API Specification
type API = "hello" :> Get '[JSON] Hello

endpoints :: Server API
endpoints = helloWorld
  where
    helloWorld :: EitherT ServantErr IO Hello
    helloWorld = pure Hello

main :: IO ()
main = do
  putStrLn "running on 8000"
  run 8000 $ serve (Proxy :: Proxy API) endpoints

