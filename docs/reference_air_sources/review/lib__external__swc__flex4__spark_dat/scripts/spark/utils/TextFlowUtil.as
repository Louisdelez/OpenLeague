package spark.utils
{
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.ITextExporter;
   import flashx.textLayout.conversion.ITextImporter;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   public class TextFlowUtil
   {
      
      private static var collapsingTextLayoutImporter:ITextImporter;
      
      private static var preservingTextLayoutImporter:ITextImporter;
      
      private static var textLayoutExporter:ITextExporter;
      
      private static var configInheritingFormats:Vector.<String>;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const TEXT_LAYOUT_NAMESPACE:String = "http://ns.adobe.com/textLayout/2008";
      
      private static var initialized:Boolean = false;
      
      public function TextFlowUtil()
      {
         super();
      }
      
      private static function initClass() : void
      {
         var format:TextLayoutFormat = null;
         var config:Configuration = null;
         var p:String = null;
         if(initialized)
         {
            return;
         }
         GlobalSettings.resourceStringFunction = TextUtil.getResourceString;
         config = new Configuration();
         format = new TextLayoutFormat(config.textFlowInitialFormat);
         format.whiteSpaceCollapse = "collapse";
         config.textFlowInitialFormat = format;
         collapsingTextLayoutImporter = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,config);
         collapsingTextLayoutImporter.throwOnError = true;
         config = new Configuration();
         format = new TextLayoutFormat(config.textFlowInitialFormat);
         format.whiteSpaceCollapse = "preserve";
         config.textFlowInitialFormat = format;
         preservingTextLayoutImporter = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,config);
         preservingTextLayoutImporter.throwOnError = true;
         textLayoutExporter = TextConverter.getExporter(TextConverter.TEXT_LAYOUT_FORMAT);
         config = new Configuration();
         configInheritingFormats = new Vector.<String>();
         var initialFormat:ITextLayoutFormat = config.textFlowInitialFormat;
         for(p in TextLayoutFormat.description)
         {
            if(initialFormat[p] == FormatValue.INHERIT)
            {
               configInheritingFormats.push(p);
            }
         }
         initialized = true;
      }
      
      [Bindable("unused")]
      public static function importFromString(markup:String, whiteSpaceCollapse:String = "collapse") : TextFlow
      {
         var oldValue:Boolean = false;
         var xml:XML = null;
         initClass();
         var markupToImport:Object = markup;
         var wrap:Boolean = true;
         if(markup.indexOf("TextFlow") != -1)
         {
            try
            {
               oldValue = Boolean(XML.ignoreWhitespace);
               XML.ignoreWhitespace = false;
               xml = XML(markup);
               XML.ignoreWhitespace = oldValue;
               if(xml.localName() == "TextFlow")
               {
                  markupToImport = xml;
                  wrap = false;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(wrap)
         {
            markupToImport = "<TextFlow xmlns=\"" + TEXT_LAYOUT_NAMESPACE + "\">" + markupToImport + "</TextFlow>";
         }
         var importer:ITextImporter = whiteSpaceCollapse == "collapse" ? collapsingTextLayoutImporter : preservingTextLayoutImporter;
         return importer.importToFlow(markupToImport);
      }
      
      [Bindable("unused")]
      public static function importFromXML(markup:XML, whiteSpaceCollapse:String = "collapse") : TextFlow
      {
         var root:XML = null;
         var ns:Namespace = null;
         var element:XML = null;
         initClass();
         if(markup.localName() != "TextFlow")
         {
            root = <TextFlow/>;
            ns = new Namespace(TEXT_LAYOUT_NAMESPACE);
            root.setNamespace(ns);
            root.setChildren(markup);
            for each(element in root..*)
            {
               element.setNamespace(ns);
            }
            markup = root;
         }
         var importer:ITextImporter = whiteSpaceCollapse == "collapse" ? collapsingTextLayoutImporter : preservingTextLayoutImporter;
         return importer.importToFlow(markup);
      }
      
      public static function export(textFlow:TextFlow) : XML
      {
         var p:String = null;
         initClass();
         var xml:XML = textLayoutExporter.export(textFlow,ConversionType.XML_TYPE) as XML;
         var n:int = int(configInheritingFormats.length);
         for(var i:int = 0; i < n; i++)
         {
            p = configInheritingFormats[i];
            if(xml[p] == FormatValue.INHERIT)
            {
               delete xml[p];
            }
         }
         return xml;
      }
   }
}

