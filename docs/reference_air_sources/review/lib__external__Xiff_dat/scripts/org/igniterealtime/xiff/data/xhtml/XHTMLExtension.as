package org.igniterealtime.xiff.data.xhtml
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class XHTMLExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "http://www.w3.org/1999/xhtml";
      
      public static var ELEMENT:String = "html";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      public function XHTMLExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(XHTMLExtension);
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         return true;
      }
      
      public function getNS() : String
      {
         return XHTMLExtension.NS;
      }
      
      public function getElementName() : String
      {
         return XHTMLExtension.ELEMENT;
      }
      
      public function get body() : String
      {
         var _loc2_:XMLNode = null;
         var _loc1_:Array = [];
         for each(_loc2_ in getNode().childNodes)
         {
            _loc1_.unshift(_loc2_.toString());
         }
         return _loc1_.join();
      }
      
      public function set body(param1:String) : void
      {
         var _loc2_:XMLNode = null;
         for each(_loc2_ in getNode().childNodes)
         {
            _loc2_.removeNode();
         }
         getNode().appendChild(new XMLDocument(param1));
      }
   }
}

