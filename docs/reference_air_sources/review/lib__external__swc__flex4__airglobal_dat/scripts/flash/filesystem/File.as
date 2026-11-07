package flash.filesystem
{
   import flash.desktop.Icon;
   import flash.errors.*;
   import flash.net.FileReference;
   
   [API("661")]
   [native(cls="FileClass",instance="FileObject",methods="auto")]
   [Event(name="directoryListing",type="flash.events.FileListEvent")]
   [Event(name="selectMultiple",type="flash.events.FileListEvent")]
   [Event(name="select",type="flash.events.Event")]
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="cancel",type="flash.events.Event")]
   public class File extends FileReference
   {
      
      private static const kInvalidCallError:uint = 2037;
      
      private static const kNullPointerError:uint = 2007;
      
      private static const kInvalidParamError:uint = 2004;
      
      private static const kFileBadPathName:uint = 3000;
      
      private static const kFileAccessDenied:* = 3001;
      
      private static const kFileDoesNotExist:* = 3003;
      
      private static const _systemCharset:String = initSystemCharset();
      
      private static const _separator:String = initSeparator();
      
      private static const _lineEnding:String = (function():String
      {
         if(separator == "\\")
         {
            return "\r\n";
         }
         return "\n";
      })();
      
      private static const kFilePermissionUpload:uint = 1;
      
      private static const kFilePermissionProgrammatic:uint = 8;
      
      private static const kFilePermissionLocalStore:uint = 16;
      
      private static const kFilePermissionTemp:uint = 32;
      
      private static const kFilePermissionAppResource:uint = 64;
      
      private static const pathIsURL:RegExp = /^ (file | app | app-storage ) : /xi;
      
      private static const parentComps:Array = [".."];
      
      private static var m_userDirectoryPath:String = null;
      
      private static var m_documentsDirectoryPath:String = null;
      
      private static var m_desktopDirectoryPath:String = null;
      
      private static var m_appDataDirectoryPath:String = null;
      
      private static var m_appStorageDirectoryPath:String = null;
      
      private static var ensureappStorageDir:Boolean = true;
      
      private static var m_appResourceDirectoryPath:String = null;
      
      private static const uriParts:RegExp = /^ (([^:\/?#]+):)? (\/\/([^\/?#]*))? ([^?#]*) (\?([^#]*))? (\#(.*))? $/xi;
      
      private static const fileUrlLocalhostPrefix:RegExp = /^ file:\/\/localhost\/ /xi;
      
      private static const m_allColons:RegExp = /:/g;
      
      private static const m_allSlashes:RegExp = /\//g;
      
      private static const m_allBackSlashes:RegExp = /\\/g;
      
      public function File(path:String = null)
      {
         super();
         if(path != null)
         {
            if(Boolean(pathIsURL.test(path)))
            {
               this.url = path;
            }
            else
            {
               this.nativePath = path;
            }
         }
      }
      
      public static function get systemCharset() : String
      {
         _checkAccessFor(null);
         return _systemCharset;
      }
      
      private static native function initSystemCharset() : String;
      
      public static function get separator() : String
      {
         return _separator;
      }
      
      private static native function initSeparator() : String;
      
      public static function get lineEnding() : String
      {
         return _lineEnding;
      }
      
      private static native function _getNativePathFor(param1:FileReference) : String;
      
      private static native function _getRedlineFor(param1:FileReference) : uint;
      
      private static native function _getFlagsFor(param1:FileReference) : uint;
      
      private static native function _getNativePath(param1:FileReference) : String;
      
      private static native function _checkAccessFor(param1:FileReference) : void;
      
      private static native function _checkPathAccessFor(param1:FileReference) : void;
      
      private static native function _checkUpdateFor(param1:FileReference) : void;
      
      private static function pathIsRelative(path:String) : Boolean
      {
         if(separator == "\\")
         {
            return path.charAt(0) != "/" && path.charAt(0) != "\\" && path.indexOf(":") < 0;
         }
         return path.charAt(0) != "/";
      }
      
      private static function pathHasPrefix(path:String, prefix:String) : *
      {
         if(path.length < prefix.length)
         {
            return false;
         }
         if(path.length == prefix.length)
         {
            return path == prefix;
         }
         if(path.substr(0,prefix.length) != prefix)
         {
            return false;
         }
         if(prefix.length > 0 && prefix.charAt(prefix.length - 1) == separator)
         {
            return true;
         }
         if(path.charAt(prefix.length) == separator)
         {
            return true;
         }
         return false;
      }
      
      private static native function initUserDir() : String;
      
      private static function get userDirectoryPath() : String
      {
         if(!m_userDirectoryPath)
         {
            m_userDirectoryPath = normalizePath(initUserDir());
         }
         return m_userDirectoryPath;
      }
      
      public static function get userDirectory() : File
      {
         return getFile(userDirectoryPath);
      }
      
      private static native function initDocumentsDir() : String;
      
      private static function get documentsDirectoryPath() : String
      {
         if(!m_documentsDirectoryPath)
         {
            m_documentsDirectoryPath = normalizePath(initDocumentsDir());
         }
         return m_documentsDirectoryPath;
      }
      
      public static function get documentsDirectory() : File
      {
         return getFile(documentsDirectoryPath);
      }
      
      private static native function initDesktopDir() : String;
      
      private static function get desktopDirectoryPath() : String
      {
         if(!m_desktopDirectoryPath)
         {
            m_desktopDirectoryPath = normalizePath(initDesktopDir());
         }
         return m_desktopDirectoryPath;
      }
      
      public static function get desktopDirectory() : File
      {
         return getFile(desktopDirectoryPath);
      }
      
      private static native function _getAppId() : String;
      
      private static native function _getPubId() : String;
      
      private static native function initAppDataDirRoot() : String;
      
      private static function get appDataDirectoryPath() : String
      {
         var pubID:String = null;
         if(!m_appDataDirectoryPath)
         {
            pubID = _getPubId();
            if(pubID == "")
            {
               m_appDataDirectoryPath = normalizePath(initAppDataDirRoot() + separator + _getAppId());
            }
            else
            {
               m_appDataDirectoryPath = normalizePath(initAppDataDirRoot() + separator + _getAppId() + "." + pubID);
            }
         }
         return m_appDataDirectoryPath;
      }
      
      private static function get appStorageDirectoryPath() : String
      {
         if(!m_appStorageDirectoryPath)
         {
            m_appStorageDirectoryPath = normalizePath(appDataDirectoryPath + separator + "Local Store");
         }
         return m_appStorageDirectoryPath;
      }
      
      public static function get applicationStorageDirectory() : File
      {
         var appStorageDir:File = getFile(appStorageDirectoryPath,kFilePermissionLocalStore);
         if(ensureappStorageDir)
         {
            appStorageDir.createDirectory();
            ensureappStorageDir = false;
         }
         return appStorageDir;
      }
      
      private static native function initAppResourceDir() : String;
      
      private static function get appResourceDirectoryPath() : String
      {
         if(!m_appResourceDirectoryPath)
         {
            m_appResourceDirectoryPath = normalizePath(initAppResourceDir());
         }
         return m_appResourceDirectoryPath;
      }
      
      public static function get applicationDirectory() : File
      {
         return getFile(appResourceDirectoryPath,kFilePermissionAppResource);
      }
      
      public static function createTempFile() : File
      {
         return new File(_createTempFile());
      }
      
      private static native function _createTempFile() : String;
      
      public static function createTempDirectory() : File
      {
         return new File(_createTempDirectory());
      }
      
      private static native function _createTempDirectory() : String;
      
      [ArrayElementType("flash.filesystem.File")]
      public static native function getRootDirectories() : Array;
      
      private static native function urlFromPath(param1:String) : String;
      
      private static native function pathFromUrl(param1:String) : String;
      
      private static function normalizePath(inPath:String, newComps:Array = null, protectBase:Boolean = false) : String
      {
         var i:int = 0;
         var comp:String = null;
         if(separator == "\\" && inPath.indexOf("/") >= 0)
         {
            inPath = inPath.replace(m_allSlashes,"\\");
         }
         var pathComps:Array = inPath.split(separator);
         var uncHost:String = null;
         var drive:String = null;
         if(separator == "\\" && pathComps.length >= 3 && pathComps[0] == "" && pathComps[1] == "" && pathComps[2] != "")
         {
            uncHost = pathComps[2];
            pathComps = pathComps.slice(3);
         }
         else if(separator == "\\" && pathComps.length >= 2 && pathComps[0].charAt(pathComps[0].length - 1) == ":")
         {
            drive = pathComps[0];
            pathComps = pathComps.slice(1);
         }
         var comps:Array = new Array();
         for(i = 0; i < pathComps.length; i++)
         {
            comp = pathComps[i];
            if(!(comp == "" || comp == "."))
            {
               if(comp == "..")
               {
                  if(comps.length > 0)
                  {
                     --comps.length;
                  }
               }
               else
               {
                  comps.push(comp);
               }
            }
         }
         var protectedComponents:uint = protectBase ? comps.length : 0;
         if(newComps != null)
         {
            for(i = 0; i < newComps.length; i++)
            {
               comp = newComps[i];
               if(!(comp == "" || comp == "."))
               {
                  if(comp == "..")
                  {
                     if(comps.length > protectedComponents)
                     {
                        --comps.length;
                     }
                  }
                  else
                  {
                     comps.push(comp);
                  }
               }
            }
         }
         var res:String = comps.join(separator);
         if(separator == "/")
         {
            res = "/" + res;
         }
         else if(uncHost != null)
         {
            res = "\\\\" + uncHost + "\\" + res;
         }
         else if(drive != null)
         {
            res = drive + "\\" + res;
         }
         else if(separator == "\\" && comps.length > 0 && comps[0].indexOf(":") < 0)
         {
            res = "\\" + res;
         }
         else if(separator == "\\" && comps.length == 1 && comps[0].indexOf(":") > 0)
         {
            res += "\\";
         }
         if(!res)
         {
            res = separator;
         }
         return res;
      }
      
      private static function getFile(normalizedPath:String, type:uint = 0, redLine:uint = 0) : File
      {
         var file:File = new File();
         file.setFileInfo(normalizedPath,type,redLine);
         return file;
      }
      
      private native function _setFileInfo(param1:String, param2:uint, param3:uint) : void;
      
      override public function toString() : String
      {
         return super.toString();
      }
      
      public function get exists() : Boolean
      {
         return this._exists();
      }
      
      private native function _exists() : Boolean;
      
      public function get isHidden() : Boolean
      {
         return this._isHidden();
      }
      
      private native function _isHidden() : Boolean;
      
      public function get isDirectory() : Boolean
      {
         return this._isDirectory();
      }
      
      private native function _isDirectory() : Boolean;
      
      public function get isPackage() : Boolean
      {
         return this._isPackage();
      }
      
      private native function _isPackage() : Boolean;
      
      public function get isSymbolicLink() : Boolean
      {
         return this._isSymbolicLink();
      }
      
      private native function _isSymbolicLink() : Boolean;
      
      override public function cancel() : void
      {
         this._cancel();
      }
      
      private native function _cancel() : void;
      
      public function resolvePath(path:String) : File
      {
         if(path == null)
         {
            Error.throwError(ArgumentError,kNullPointerError);
         }
         if(pathIsRelative(path))
         {
            if(separator == "\\")
            {
               path = path.replace(m_allBackSlashes,"/");
            }
            return this.resolveComponents(path.split("/"));
         }
         return new File(path);
      }
      
      private function resolveComponents(components:Array, target:File = null, protectBase:Boolean = false) : File
      {
         if(!target)
         {
            target = new File();
         }
         var basePath:String = _getNativePathFor(this);
         if(basePath == null)
         {
            Error.throwError(IllegalOperationError,kInvalidCallError);
         }
         var path:String = normalizePath(basePath,components,protectBase);
         var redLine:uint = uint(_getRedlineFor(this));
         var flags:uint = uint(_getFlagsFor(this));
         var prefix:String = basePath.substr(0,redLine);
         if(redLine != 0 && !pathHasPrefix(path,prefix))
         {
            if(Boolean(flags & (kFilePermissionLocalStore | kFilePermissionAppResource)))
            {
               path = prefix;
            }
            else
            {
               flags = uint(kFilePermissionProgrammatic);
               redLine = 0;
            }
         }
         target.setFileInfo(path,flags,redLine);
         return target;
      }
      
      public function getRelativePath(ref:FileReference, useDotDot:Boolean = false) : String
      {
         if(!ref)
         {
            Error.throwError(ArgumentError,kNullPointerError);
         }
         _checkAccessFor(this);
         _checkAccessFor(ref);
         if((_getFlagsFor(this) & kFilePermissionLocalStore) != (_getFlagsFor(ref) & kFilePermissionLocalStore))
         {
            return null;
         }
         if((_getFlagsFor(this) & kFilePermissionAppResource) != (_getFlagsFor(ref) & kFilePermissionAppResource))
         {
            return null;
         }
         var path1:String = _getNativePathFor(this);
         var path2:String = _getNativePathFor(ref);
         var comps1:Array = path1.split(separator);
         var comps2:Array = path2.split(separator);
         if(comps1.length == 1 && comps1[0] == "")
         {
            comps1.length = 0;
         }
         if(comps2.length == 1 && comps2[0] == "")
         {
            comps2.length = 0;
         }
         if(!useDotDot && comps2.length < comps1.length)
         {
            return null;
         }
         var nCommon:int = 0;
         while(nCommon < comps1.length && nCommon < comps2.length)
         {
            if(comps1[nCommon] != comps2[nCommon])
            {
               break;
            }
            nCommon++;
         }
         if(useDotDot)
         {
            if(nCommon < 1)
            {
               return null;
            }
            if(separator == "\\" && nCommon < 3 && comps1[0] == "" && comps1[1] == "")
            {
               return null;
            }
            if(separator == "/" && nCommon < 3 && comps1[0] == "" && (comps1[1] == "mnt" || comps1[1] == "Volumes"))
            {
               return null;
            }
         }
         else if(nCommon != comps1.length)
         {
            return null;
         }
         var comps:Array = comps2.slice(nCommon);
         while(nCommon++ < comps1.length)
         {
            comps.unshift("..");
         }
         return comps.join("/");
      }
      
      public function get parent() : File
      {
         var p:File = this.resolveComponents(parentComps);
         if(_getNativePathFor(p) == _getNativePathFor(this))
         {
            return null;
         }
         return p;
      }
      
      public function get nativePath() : String
      {
         _checkPathAccessFor(this);
         return _getNativePath(this);
      }
      
      public function set nativePath(value:String) : void
      {
         _checkAccessFor(null);
         if(value == null)
         {
            Error.throwError(ArgumentError,kNullPointerError);
         }
         if(value == "" || Boolean(pathIsRelative(value)))
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         this._setFileInfo(normalizePath(value),kFilePermissionProgrammatic,0);
      }
      
      private native function _getCanonicalPath() : String;
      
      public function canonicalize() : void
      {
         _checkPathAccessFor(this);
         var origPath:String = this._getCanonicalPath();
         var path:String = normalizePath(origPath);
         var redLine:uint = uint(_getRedlineFor(this));
         var flags:uint = uint(_getFlagsFor(this));
         if(redLine != 0 && !pathHasPrefix(path,origPath.substr(0,redLine)))
         {
            flags = uint(kFilePermissionProgrammatic);
            redLine = 0;
         }
         this._setFileInfo(path,flags,redLine);
      }
      
      public function get url() : String
      {
         var relPath:String = null;
         var components:Array = null;
         var i:int = 0;
         _checkAccessFor(this);
         if(Boolean(_getFlagsFor(this) & kFilePermissionLocalStore))
         {
            relPath = applicationStorageDirectory.getRelativePath(this);
            if(relPath == null)
            {
               Error.throwError(IllegalOperationError,kInvalidCallError);
            }
            components = relPath.split("/");
            relPath = "";
            for(i = 0; i < components.length; i++)
            {
               relPath += "/" + encodeURIComponent(components[i]);
            }
            if(relPath == "")
            {
               relPath = "/";
            }
            return "app-storage:" + relPath;
         }
         if(Boolean(_getFlagsFor(this) & kFilePermissionAppResource))
         {
            relPath = applicationDirectory.getRelativePath(this);
            if(relPath == null)
            {
               Error.throwError(IllegalOperationError,kInvalidCallError);
            }
            components = relPath.split("/");
            relPath = "";
            for(i = 0; i < components.length; i++)
            {
               relPath += "/" + encodeURIComponent(components[i]);
            }
            if(relPath == "")
            {
               relPath = "/";
            }
            return "app:" + relPath;
         }
         var url:String = urlFromPath(_getNativePathFor(this));
         if(url == "file:")
         {
            url = "file:///";
         }
         if(Boolean(fileUrlLocalhostPrefix.test(url)))
         {
            url = url.replace(fileUrlLocalhostPrefix,"file:///");
         }
         return url;
      }
      
      public function set url(value:String) : void
      {
         var match:Object = uriParts.exec(value);
         if(!match || !match[2])
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         var scheme:String = match[2].toLowerCase();
         if(Boolean(match[4]) && match[4] != "localhost")
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         var path:String = match[5];
         if(path.charAt(0) != "/")
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         switch(scheme)
         {
            case "file":
               this.nativePath = pathFromUrl("file://" + path);
               break;
            case "app-storage":
               path = decodeURIComponent(path);
               applicationStorageDirectory.resolveComponents(path.split("/"),this,true);
               break;
            case "app":
               path = decodeURIComponent(path);
               applicationDirectory.resolveComponents(path.split("/"),this,true);
               break;
            default:
               Error.throwError(ArgumentError,kInvalidParamError);
         }
      }
      
      public native function browseForOpen(param1:String, param2:Array = null) : void;
      
      public native function browseForOpenMultiple(param1:String, param2:Array = null) : void;
      
      public native function browseForSave(param1:String) : void;
      
      public native function browseForDirectory(param1:String) : void;
      
      public native function deleteFile() : void;
      
      public native function deleteFileAsync() : void;
      
      public native function deleteDirectory(param1:Boolean = false) : void;
      
      public native function deleteDirectoryAsync(param1:Boolean = false) : void;
      
      public native function copyTo(param1:FileReference, param2:Boolean = false) : void;
      
      public native function copyToAsync(param1:FileReference, param2:Boolean = false) : void;
      
      public native function moveTo(param1:FileReference, param2:Boolean = false) : void;
      
      public native function moveToAsync(param1:FileReference, param2:Boolean = false) : void;
      
      public native function moveToTrash() : void;
      
      public native function moveToTrashAsync() : void;
      
      public native function createDirectory() : void;
      
      [ArrayElementType("flash.filesystem.File")]
      public native function getDirectoryListing() : Array;
      
      public native function getDirectoryListingAsync() : void;
      
      public function clone() : File
      {
         var nativePath:String = _getNativePathFor(this);
         if(Boolean(nativePath))
         {
            return getFile(nativePath,_getFlagsFor(this),_getRedlineFor(this));
         }
         return new File();
      }
      
      private function setFileInfo(normalizedPath:String, type:uint = 0, redLine:uint = 0) : void
      {
         if(Boolean(type & (kFilePermissionLocalStore | kFilePermissionAppResource | kFilePermissionTemp)) && redLine == 0)
         {
            redLine = uint(normalizedPath.length);
         }
         this._setFileInfo(normalizedPath,type | kFilePermissionProgrammatic,redLine);
      }
      
      public native function get icon() : Icon;
      
      public native function get spaceAvailable() : Number;
      
      [Version("air2.0")]
      public function openWithDefaultApplication() : void
      {
         if(this._isInApplicationStorageDirectory())
         {
            Error.throwError(IllegalOperationError,kFileBadPathName);
         }
         _checkAccessFor(this);
         if(this._isBlackListed())
         {
            Error.throwError(IllegalOperationError,kFileAccessDenied);
         }
         if(!this.exists)
         {
            Error.throwError(IOError,kFileDoesNotExist);
         }
         this._openWithDefaultApplication();
      }
      
      private native function _openWithDefaultApplication() : void;
      
      private native function _isBlackListed() : Boolean;
      
      private function _isInApplicationStorageDirectory() : Boolean
      {
         var basePath:String = _getNativePathFor(this);
         return pathHasPrefix(basePath,appResourceDirectoryPath);
      }
      
      [Version("air2.0")]
      public function get downloaded() : Boolean
      {
         _checkAccessFor(this);
         return this._getDownloadedStatus();
      }
      
      [Version("air2.0")]
      public function set downloaded(value:Boolean) : void
      {
         _checkAccessFor(this);
         this._setDownloadedStatus(value);
      }
      
      private native function _setDownloadedStatus(param1:Boolean) : void;
      
      private native function _getDownloadedStatus() : Boolean;
   }
}

