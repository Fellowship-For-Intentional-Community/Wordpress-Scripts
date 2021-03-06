{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad                  ( forM_ )
import           Data.Maybe                     ( mapMaybe )
import           Database.Persist.Sql           ( (=.)
                                                , Entity(..)
                                                , fromSqlKey
                                                , update
                                                )
import           System.Console.CmdArgs.Implicit
                                                ( (&=)
                                                , cmdArgs
                                                , program
                                                , summary
                                                , help
                                                )

import           DB                             ( runDB
                                                , getListings
                                                )
import           Schema

main :: IO ()
main = do
    cmdArgs args
    runDB $ do
        ls <- getListings
        let postIds = filter ((/=) 0 . fromSqlKey)
                $ mapMaybe (\(e, _, _) -> formItemPost $ entityVal e) ls
        forM_ postIds $ \pId -> update pId [PostContent =. "[directory_elm]"]

args :: ()
args =
    ()
        &= program "directory-migrate-elm-details"
        &= summary "Migrate Directory Posts to Elm"
        &= help
               "This script modifies the post contents for any Directory Entries to use the `elm_directory` shortcode."
