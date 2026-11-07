package spark.utils
{
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.compose.TextLineRecycler;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import mx.core.EmbeddedFont;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("textLayout")]
   [ExcludeClass]
   public class TextUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TextUtil()
      {
         super();
      }
      
      public static function getResourceString(resourceName:String, args:Array = null) : String
      {
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         return resourceManager.getString("textLayout",resourceName,args);
      }
      
      public static function resolveFontLookup(swfContext:ISWFContext, format:ITextLayoutFormat) : String
      {
         var name:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var font:EmbeddedFont = null;
         var registry:IEmbeddedFontRegistry = null;
         if(Boolean(swfContext as IFlexModuleFactory) && format.fontLookup == FontLookup.EMBEDDED_CFF)
         {
            name = format.fontFamily;
            bold = format.fontWeight == "bold";
            italic = format.fontStyle == "italic";
            font = new EmbeddedFont(name,bold,italic);
            registry = UIComponent.embeddedFontRegistry;
            if(Boolean(registry) && Boolean(registry.isFontRegistered(font,IFlexModuleFactory(swfContext))))
            {
               return FontLookup.EMBEDDED_CFF;
            }
            if(Boolean(swfContext.callInContext(FontDescription.isFontCompatible,FontDescription,[name,format.fontWeight,format.fontStyle])))
            {
               return FontLookup.EMBEDDED_CFF;
            }
         }
         else if(FontDescription.isFontCompatible(format.fontFamily,format.fontWeight,format.fontStyle))
         {
            return FontLookup.EMBEDDED_CFF;
         }
         return FontLookup.DEVICE;
      }
      
      public static function recycleTextLine(textLine:TextLine) : void
      {
         if(Boolean(textLine))
         {
            if(textLine.validity != TextLineValidity.INVALID && textLine.validity != TextLineValidity.STATIC)
            {
               textLine.validity = TextLineValidity.INVALID;
            }
            textLine.userData = null;
            TextLineRecycler.addLineForReuse(textLine);
         }
      }
   }
}

