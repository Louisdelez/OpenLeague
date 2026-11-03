package mx.core
{
   import flash.system.Capabilities;
   import flash.text.FontStyle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.engine.FontDescription;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.managers.ISystemManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class EmbeddedFontRegistry implements IEmbeddedFontRegistry
   {
      
      private static var instance:IEmbeddedFontRegistry;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var fonts:Object = {};
      
      private static var cachedFontsForObjects:Dictionary = new Dictionary(true);
      
      private static var staticTextFormat:TextFormat = new TextFormat();
      
      private static var flaggedObjects:Dictionary = new Dictionary(true);
      
      private var _resourceManager:IResourceManager;
      
      public function EmbeddedFontRegistry()
      {
         super();
      }
      
      public static function getInstance() : IEmbeddedFontRegistry
      {
         if(!instance)
         {
            instance = new EmbeddedFontRegistry();
         }
         return instance;
      }
      
      private static function createFontKey(font:EmbeddedFont) : String
      {
         return font.fontName + font.fontStyle;
      }
      
      private static function createEmbeddedFont(key:String) : EmbeddedFont
      {
         var fontName:String = null;
         var fontBold:Boolean = false;
         var fontItalic:Boolean = false;
         var index:int = endsWith(key,FontStyle.REGULAR);
         if(index > 0)
         {
            fontName = key.substring(0,index);
            return new EmbeddedFont(fontName,false,false);
         }
         index = endsWith(key,FontStyle.BOLD);
         if(index > 0)
         {
            fontName = key.substring(0,index);
            return new EmbeddedFont(fontName,true,false);
         }
         index = endsWith(key,FontStyle.BOLD_ITALIC);
         if(index > 0)
         {
            fontName = key.substring(0,index);
            return new EmbeddedFont(fontName,true,true);
         }
         index = endsWith(key,FontStyle.ITALIC);
         if(index > 0)
         {
            fontName = key.substring(0,index);
            return new EmbeddedFont(fontName,false,true);
         }
         return new EmbeddedFont("",false,false);
      }
      
      private static function endsWith(s:String, match:String) : int
      {
         var index:int = s.lastIndexOf(match);
         if(index > 0 && index + match.length == s.length)
         {
            return index;
         }
         return -1;
      }
      
      public static function registerFonts(fonts:Object, moduleFactory:IFlexModuleFactory) : void
      {
         var fontRegistry:IEmbeddedFontRegistry = null;
         var f:Object = null;
         var fontObj:Object = null;
         var fieldIter:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         try
         {
            fontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
         }
         catch(e:Error)
         {
            Singleton.registerClass("mx.core::IEmbeddedFontRegistry",EmbeddedFontRegistry);
            fontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
         }
         for(f in fonts)
         {
            fontObj = fonts[f];
            for(fieldIter in fontObj)
            {
               if(fontObj[fieldIter] != false)
               {
                  if(fieldIter == "regular")
                  {
                     bold = false;
                     italic = false;
                  }
                  else if(fieldIter == "boldItalic")
                  {
                     bold = true;
                     italic = true;
                  }
                  else if(fieldIter == "bold")
                  {
                     bold = true;
                     italic = false;
                  }
                  else if(fieldIter == "italic")
                  {
                     bold = false;
                     italic = true;
                  }
                  fontRegistry.registerFont(new EmbeddedFont(String(f),bold,italic),moduleFactory);
               }
            }
         }
      }
      
      private function get resourceManager() : IResourceManager
      {
         if(!this._resourceManager)
         {
            this._resourceManager = ResourceManager.getInstance();
         }
         return this._resourceManager;
      }
      
      public function getFontStyle(bold:Boolean, italic:Boolean) : String
      {
         var style:String = FontStyle.REGULAR;
         if(bold && italic)
         {
            style = FontStyle.BOLD_ITALIC;
         }
         else if(bold)
         {
            style = FontStyle.BOLD;
         }
         else if(italic)
         {
            style = FontStyle.ITALIC;
         }
         return style;
      }
      
      public function registerFont(font:EmbeddedFont, moduleFactory:IFlexModuleFactory) : void
      {
         var fontKey:String = createFontKey(font);
         var fontDictionary:Dictionary = fonts[fontKey];
         if(!fontDictionary)
         {
            fontDictionary = new Dictionary(true);
            fonts[fontKey] = fontDictionary;
         }
         fontDictionary[moduleFactory] = 1;
      }
      
      public function deregisterFont(font:EmbeddedFont, moduleFactory:IFlexModuleFactory) : void
      {
         var count:int = 0;
         var obj:Object = null;
         var fontKey:String = createFontKey(font);
         var fontDictionary:Dictionary = fonts[fontKey];
         if(fontDictionary != null)
         {
            delete fontDictionary[moduleFactory];
            count = 0;
            for(obj in fontDictionary)
            {
               count++;
            }
            if(count == 0)
            {
               delete fonts[fontKey];
            }
         }
      }
      
      public function isFontRegistered(font:EmbeddedFont, moduleFactory:IFlexModuleFactory) : Boolean
      {
         var fontKey:String = createFontKey(font);
         var fontDictionary:Dictionary = fonts[fontKey];
         return Boolean(fontDictionary) && fontDictionary[moduleFactory] == 1;
      }
      
      public function getFonts() : Array
      {
         var key:String = null;
         var fontArray:Array = [];
         for(key in fonts)
         {
            fontArray.push(createEmbeddedFont(key));
         }
         return fontArray;
      }
      
      public function getAssociatedModuleFactory(fontName:String, bold:Boolean, italic:Boolean, object:Object, defaultModuleFactory:IFlexModuleFactory, systemManager:ISystemManager, embeddedCff:* = undefined) : IFlexModuleFactory
      {
         var font:EmbeddedFont = null;
         var result:IFlexModuleFactory = null;
         var found:int = 0;
         var iter:Object = null;
         var compatible:Boolean = false;
         var objName:String = null;
         font = cachedFontsForObjects[object];
         if(!font)
         {
            font = new EmbeddedFont(fontName,bold,italic);
            cachedFontsForObjects[object] = font;
         }
         else if(font.fontName != fontName || font.bold != bold || font.italic != italic)
         {
            font = new EmbeddedFont(fontName,bold,italic);
            cachedFontsForObjects[object] = font;
         }
         var fontDictionary:Dictionary = fonts[createFontKey(font)];
         if(Boolean(fontDictionary))
         {
            found = int(fontDictionary[defaultModuleFactory]);
            if(Boolean(found))
            {
               result = defaultModuleFactory;
            }
            else
            {
               var _loc15_:int = 0;
               var _loc16_:* = fontDictionary;
               for(iter in _loc16_)
               {
                  result = iter as IFlexModuleFactory;
               }
            }
         }
         if(!result && Boolean(systemManager))
         {
            staticTextFormat.font = fontName;
            staticTextFormat.bold = bold;
            staticTextFormat.italic = italic;
            if(systemManager.isFontFaceEmbedded(staticTextFormat))
            {
               result = systemManager;
            }
         }
         if(Boolean(result) && Boolean(embeddedCff != undefined) && Capabilities.isDebugger)
         {
            compatible = Boolean(embeddedCff) ? Boolean(result.callInContext(FontDescription.isFontCompatible,null,[fontName,bold ? "bold" : "normal",italic ? "italic" : "normal"])) : Boolean(result.callInContext(TextField.isFontCompatible,null,[fontName,this.getFontStyle(bold,italic)]));
            if(!compatible)
            {
               if(!flaggedObjects[object])
               {
                  objName = getQualifiedClassName(object);
                  objName += "name" in object && object.name != null ? " (" + object.name + ") " : "";
                  trace(this.resourceManager.getString("core","fontIncompatible",[fontName,objName,embeddedCff]));
                  flaggedObjects[object] = true;
               }
            }
         }
         return result;
      }
   }
}

