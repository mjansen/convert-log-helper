module ConvertLogHelper
       ( ConvertLogInfo(..)
       , convertLog
       , convertLogIfNeeded
       ) where

import System.FilePath
import System.Directory
import System.Directory.Traversal
import ComputeDigest

data ConvertLogInfo = ConvertLogInfo
  { cli_serialized :: FilePath -> FilePath
  , cli_digest     :: FilePath -> FilePath
  , cli_convert    :: FilePath -> FilePath -> IO ()
  }
  
data LogInfo = LogInfo
  { li_fileName    :: FilePath
  , li_fixedName   :: FilePath
  , li_fileDigest  :: String
  , li_fixedDigest :: String
  } deriving (Eq, Ord, Show, Read)
             
convertLog :: ConvertLogInfo -> FilePath -> IO ()
convertLog cli fileName = do
  let digestName = cli_digest     cli fileName
      fixedName  = cli_serialized cli fileName
  ensureDirectory . takeDirectory $ fixedName
  cli_convert cli fileName fixedName
  d1 <- computeDigest fileName
  d2 <- computeDigest fixedName
  ensureDirectory . takeDirectory $ digestName
  writeFile digestName . show $ LogInfo (takeFileName fileName) (takeFileName fixedName) d1 d2

convertLogIfNeeded :: ConvertLogInfo -> FilePath -> IO ()
convertLogIfNeeded cli fileName = do
  let digestName = cli_digest     cli fileName
      fixedName  = cli_serialized cli fileName
  ok <- doesFileExist digestName
  if not ok
    then convertLog cli fileName
    else do
      LogInfo fileNameA fixedNameA d1A d2A <- read <$> readFile digestName
      d1B <- computeDigest fileName
      d2B <- computeDigest fixedName
      if (length d1B /= 0 && length d2B /= 0 &&
          d1A == d1B && fileNameA  == takeFileName fileName &&
          d2A == d2B && fixedNameA == takeFileName fixedName)
        then return ()
        else convertLog cli fileName
