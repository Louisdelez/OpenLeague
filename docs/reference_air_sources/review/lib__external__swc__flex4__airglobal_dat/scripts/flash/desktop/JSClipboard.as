package flash.desktop
{
   import flash.display.*;
   import flash.filesystem.*;
   
   [native(construct="native")]
   [API("661")]
   public class JSClipboard
   {
      
      private static const TEXT_TYPE:String = "text/plain";
      
      private static const HTML_TYPE:String = "text/html";
      
      private static const URI_LIST_TYPE:String = "text/uri-list";
      
      private static const BITMAP_TYPE:String = "image/x-vnd.adobe.air.bitmap";
      
      private static const FILE_LIST_TYPE:String = "application/x-vnd.adobe.air.file-list";
      
      private static const _dropEffectNames:Array = ["none","copy","move","copyMove","link","copyLink","linkMove","all"];
      
      private var _writable:Boolean;
      
      private var _forDragging:Boolean;
      
      private var _clipboard:Clipboard;
      
      private var _dragOptions:NativeDragOptions;
      
      private var _dropAction:String;
      
      private var _propagationStopped:Boolean = false;
      
      public function JSClipboard(writable:Boolean, forDragging:Boolean, clipboard:Clipboard = null, dragOptions:NativeDragOptions = null)
      {
         super();
         this._writable = writable;
         this._forDragging = forDragging;
         this._clipboard = clipboard;
         if(!this._clipboard)
         {
            this._clipboard = new Clipboard();
         }
         if(this._forDragging)
         {
            this._dragOptions = dragOptions;
            if(!this._dragOptions)
            {
               this._dragOptions = new NativeDragOptions();
            }
            this._dropAction = NativeDragActions.NONE;
         }
      }
      
      public static function urisFromURIList(uriList:String) : Array
      {
         var uris:Array = uriList.split(/\b\r?\n\b/);
         if(uris.length == 0)
         {
            return uris;
         }
         if(Boolean(uris[0].match(/^#/)))
         {
            uris.shift();
         }
         return uris;
      }
      
      public function get dropEffect() : String
      {
         return this._dropAction;
      }
      
      public function set dropEffect(effect:String) : void
      {
         if(!this._forDragging)
         {
            return;
         }
         if(effect == NativeDragActions.COPY || effect == NativeDragActions.MOVE || effect == NativeDragActions.LINK || effect == NativeDragActions.NONE)
         {
            this._dropAction = effect;
         }
      }
      
      public function get effectAllowed() : String
      {
         var index:uint = 0;
         if(this._dragOptions == null)
         {
            index = 7;
         }
         else
         {
            if(this._dragOptions.allowCopy)
            {
               index += 1;
            }
            if(this._dragOptions.allowMove)
            {
               index += 2;
            }
            if(this._dragOptions.allowLink)
            {
               index += 4;
            }
         }
         return _dropEffectNames[index];
      }
      
      public function set effectAllowed(effectAllowed:String) : void
      {
         if(!this._writable)
         {
            return;
         }
         var index:int = int(_dropEffectNames.indexOf(effectAllowed));
         if(index >= 0)
         {
            this._dragOptions.allowCopy = index & 1;
            this._dragOptions.allowMove = index & 2;
            this._dragOptions.allowLink = index & 4;
         }
      }
      
      public function get propagationStopped() : Boolean
      {
         return this._propagationStopped;
      }
      
      public function set propagationStopped(stopped:Boolean) : void
      {
         this._propagationStopped = stopped;
      }
      
      public function getData(mimeType:String) : Object
      {
         if(mimeType == TEXT_TYPE)
         {
            return this._clipboard.getData(ClipboardFormats.TEXT_FORMAT);
         }
         if(mimeType == HTML_TYPE)
         {
            return this._clipboard.getData(ClipboardFormats.HTML_FORMAT);
         }
         if(mimeType == URI_LIST_TYPE)
         {
            return this._clipboard.getData(ClipboardFormats.URL_FORMAT);
         }
         if(mimeType == BITMAP_TYPE)
         {
            return this._clipboard.getData(ClipboardFormats.BITMAP_FORMAT);
         }
         if(mimeType == FILE_LIST_TYPE)
         {
            return this._clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
         }
         return this._clipboard.getData(mimeType);
      }
      
      public function setData(mimeType:String, data:Object) : Boolean
      {
         var uriList:String = null;
         var uriArray:Array = null;
         var files:Array = null;
         var i:uint = 0;
         if(!this._writable)
         {
            return false;
         }
         if(mimeType == TEXT_TYPE)
         {
            if(!data is String)
            {
               throw new TypeError("Data for " + TEXT_TYPE + " must be of type String");
            }
            return this._clipboard.setData(ClipboardFormats.TEXT_FORMAT,data);
         }
         if(mimeType == HTML_TYPE)
         {
            if(!data is String)
            {
               throw new TypeError("Data for " + HTML_TYPE + " must be of type String");
            }
            return this._clipboard.setData(ClipboardFormats.HTML_FORMAT,data);
         }
         if(mimeType == URI_LIST_TYPE)
         {
            if(!data is String)
            {
               throw new TypeError("Data for " + URI_LIST_TYPE + " must be of type String");
            }
            uriList = data as String;
            uriArray = urisFromURIList(uriList);
            if(uriArray.length == 1)
            {
               return this._clipboard.setData(ClipboardFormats.URL_FORMAT,uriArray[0]);
            }
            return false;
         }
         if(mimeType == BITMAP_TYPE)
         {
            if(!data is BitmapData)
            {
               throw new TypeError("Data for " + BITMAP_TYPE + " must be of type flash.display.BitmapData");
            }
            return this._clipboard.setData(ClipboardFormats.BITMAP_FORMAT,data);
         }
         if(mimeType == FILE_LIST_TYPE)
         {
            if(!data is Array && !data.hasOwnProperty("length"))
            {
               throw new TypeError("Data for " + FILE_LIST_TYPE + " must be an array containing objects of type flash.filesystem.File");
            }
            if(data is Array)
            {
               files = data as Array;
            }
            else
            {
               files = [];
               for(i = 0; i < data.length; i++)
               {
                  files.push(data[i]);
               }
            }
            for(i = 0; i < files.length; i++)
            {
               if(!files[i] is File)
               {
                  throw new TypeError("Data for " + FILE_LIST_TYPE + " must be an array containing objects of type flash.filesystem.File");
               }
            }
            return this._clipboard.setData(ClipboardFormats.FILE_LIST_FORMAT,files);
         }
         return this._clipboard.setData(mimeType,data);
      }
      
      public function clearData(mimeType:String) : void
      {
         if(!this._writable)
         {
            return;
         }
         if(mimeType == TEXT_TYPE)
         {
            this._clipboard.clearData(ClipboardFormats.TEXT_FORMAT);
         }
         else if(mimeType == HTML_TYPE)
         {
            this._clipboard.clearData(ClipboardFormats.HTML_FORMAT);
         }
         else if(mimeType == URI_LIST_TYPE)
         {
            this._clipboard.clearData(ClipboardFormats.URL_FORMAT);
         }
         else if(mimeType == BITMAP_TYPE)
         {
            this._clipboard.clearData(ClipboardFormats.BITMAP_FORMAT);
         }
         else if(mimeType == FILE_LIST_TYPE)
         {
            this._clipboard.clearData(ClipboardFormats.FILE_LIST_FORMAT);
         }
         else
         {
            this._clipboard.clearData(mimeType);
         }
      }
      
      public function clearAllData() : void
      {
         this._clipboard.clear();
      }
      
      public function get types() : Array
      {
         var f:String = null;
         var t:String = null;
         var ta:Array = [];
         var formats:Array = this._clipboard.formats;
         for each(f in formats)
         {
            switch(f)
            {
               case ClipboardFormats.TEXT_FORMAT:
                  t = TEXT_TYPE;
                  break;
               case ClipboardFormats.HTML_FORMAT:
                  t = HTML_TYPE;
                  break;
               case ClipboardFormats.URL_FORMAT:
                  t = URI_LIST_TYPE;
                  break;
               case ClipboardFormats.BITMAP_FORMAT:
                  t = BITMAP_TYPE;
                  break;
               case ClipboardFormats.FILE_LIST_FORMAT:
                  t = FILE_LIST_TYPE;
                  break;
               default:
                  t = f;
            }
            ta.push(t);
         }
         return ta;
      }
      
      public function get dragOptions() : NativeDragOptions
      {
         return this._dragOptions;
      }
      
      public function set dragOptions(dragOptions:NativeDragOptions) : void
      {
         this._dragOptions = dragOptions;
      }
      
      public function get clipboard() : Clipboard
      {
         return this._clipboard;
      }
   }
}

