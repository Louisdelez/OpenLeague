package spark.core
{
   import flash.text.engine.FontLookup;
   import flash.text.engine.Kerning;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   import mx.core.mx_internal;
   import mx.styles.IStyleClient;
   
   [ExcludeClass]
   public class CSSTextLayoutFormat extends TextLayoutFormat
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function CSSTextLayoutFormat(client:IStyleClient)
      {
         var prop:Property = null;
         var propName:String = null;
         var value:* = undefined;
         super();
         for each(prop in TextLayoutFormat.tlf_internal::description)
         {
            propName = prop.name;
            if(propName == "fontLookup")
            {
               this[propName] = convertedFontLookup(client);
            }
            else if(propName == "kerning")
            {
               this[propName] = convertedKerning(client);
            }
            else
            {
               value = client.getStyle(propName);
               if(value !== undefined)
               {
                  this[propName] = value;
               }
            }
         }
      }
      
      private static function convertedFontLookup(client:IStyleClient) : *
      {
         var value:String = client.getStyle("fontLookup");
         if(value == "auto")
         {
            if(Boolean(client.mx_internal::embeddedFontContext))
            {
               value = FontLookup.EMBEDDED_CFF;
            }
            else
            {
               value = FontLookup.DEVICE;
            }
         }
         return value;
      }
      
      private static function convertedKerning(client:IStyleClient) : *
      {
         var kerning:Object = client.getStyle("kerning");
         switch(kerning)
         {
            case "default":
               kerning = Kerning.AUTO;
               break;
            case true:
               kerning = Kerning.ON;
               break;
            case false:
               kerning = Kerning.OFF;
         }
         return kerning;
      }
   }
}

