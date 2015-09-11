module ComputeDigest where

import Data.Digest.Pure.SHA
import qualified Data.ByteString.Lazy as L

computeDigest :: FilePath -> IO String
computeDigest fName = showDigest . sha1 <$>  L.readFile fName
