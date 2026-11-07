package spark.utils
{
   import flash.text.TextFormat;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.ISWFContext;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFlexModuleFactory;
   import mx.core.IUIComponent;
   import mx.core.Singleton;
   import mx.managers.ISystemManager;
   import mx.styles.IStyleClient;
   
   [ExcludeClass]
   public class FTETextUtil
   {
      
      private static var staticTextFormat:TextFormat;
      
      private static var noEmbeddedFonts:Boolean;
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function FTETextUtil()
      {
         super();
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry && !noEmbeddedFonts)
         {
            try
            {
               _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            }
            catch(e:Error)
            {
               noEmbeddedFonts = true;
            }
         }
         return _embeddedFontRegistry;
      }
      
      public static function calculateFontBaseline(client:IStyleClient, height:Number, moduleFactory:IFlexModuleFactory) : Number
      {
         var embeddedFontContext:IFlexModuleFactory = null;
         var s:String = null;
         var textLine:TextLine = null;
         var swfContext:ISWFContext = null;
         var fontDescription:FontDescription = new FontDescription();
         s = client.getStyle("cffHinting");
         if(s != null)
         {
            fontDescription.cffHinting = s;
         }
         s = client.getStyle("fontFamily");
         if(s != null)
         {
            fontDescription.fontName = s;
         }
         s = client.getStyle("fontLookup");
         if(s != null)
         {
            if(s == "auto")
            {
               embeddedFontContext = getEmbeddedFontContext(client,moduleFactory);
               s = Boolean(embeddedFontContext) ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
            }
            fontDescription.fontLookup = s;
         }
         s = client.getStyle("fontStyle");
         if(s != null)
         {
            fontDescription.fontPosture = s;
         }
         s = client.getStyle("fontWeight");
         if(s != null)
         {
            fontDescription.fontWeight = s;
         }
         var elementFormat:ElementFormat = new ElementFormat();
         elementFormat.fontDescription = fontDescription;
         elementFormat.fontSize = client.getStyle("fontSize");
         var textElement:TextElement = new TextElement();
         textElement.elementFormat = elementFormat;
         textElement.text = "Wj";
         var textBlock:TextBlock = new TextBlock();
         textBlock.content = textElement;
         if(Boolean(embeddedFontContext))
         {
            swfContext = ISWFContext(embeddedFontContext);
            textLine = swfContext.callInContext(textBlock.createTextLine,textBlock,[null,1000]);
         }
         else
         {
            textLine = textBlock.createTextLine(null,1000);
         }
         if(height < 2 + textLine.ascent + 2)
         {
            return int(height + (textLine.ascent - height) / 2);
         }
         return 2 + textLine.ascent;
      }
      
      private static function getEmbeddedFontContext(client:IStyleClient, moduleFactory:IFlexModuleFactory) : IFlexModuleFactory
      {
         var fontContext:IFlexModuleFactory = null;
         var font:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var localLookup:ISystemManager = null;
         var uic:IUIComponent = null;
         var fontLookup:String = client.getStyle("fontLookup");
         if(fontLookup != FontLookup.DEVICE)
         {
            font = client.getStyle("fontFamily");
            bold = client.getStyle("fontWeight") == "bold";
            italic = client.getStyle("fontStyle") == "italic";
            if(moduleFactory != null && moduleFactory is ISystemManager)
            {
               localLookup = ISystemManager(moduleFactory);
            }
            else if(client is IUIComponent)
            {
               uic = IUIComponent(client);
               if(uic.parent is IUIComponent)
               {
                  localLookup = IUIComponent(uic.parent).systemManager;
               }
            }
            fontContext = embeddedFontRegistry.getAssociatedModuleFactory(font,bold,italic,client,moduleFactory,localLookup,true);
         }
         if(!fontContext && fontLookup == FontLookup.EMBEDDED_CFF)
         {
            fontContext = moduleFactory;
         }
         return fontContext;
      }
   }
}

