package blix.util.xml
{
   public class XMLUtilsSparkManifest_4_1
   {
      
      private static var FxManifest:Class = XMLUtilsSparkManifest_4_1_FxManifest;
      
      private static var SparkManifest:Class = XMLUtilsSparkManifest_4_1_SparkManifest;
      
      private static var MxManifest:Class = XMLUtilsSparkManifest_4_1_MxManifest;
      
      public function XMLUtilsSparkManifest_4_1()
      {
         super();
      }
      
      public static function initialize() : void
      {
         XMLUtils.parseManifest(XML(new FxManifest()),new Namespace("fx","http://ns.adobe.com/mxml/2009"));
         XMLUtils.parseManifest(XML(new SparkManifest()),new Namespace("s","library://ns.adobe.com/flex/spark"));
         XMLUtils.parseManifest(XML(new MxManifest()),new Namespace("mx","library://ns.adobe.com/flex/mx"));
      }
   }
}

