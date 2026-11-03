package org.igniterealtime.xiff.data.whiteboard
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class WhiteboardExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "xiff:wb";
      
      public static var ELEMENT:String = "x";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      private var myPaths:Array;
      
      public function WhiteboardExtension(param1:XMLNode = null)
      {
         super(param1);
         this.myPaths = new Array();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(WhiteboardExtension);
      }
      
      public function getNS() : String
      {
         return WhiteboardExtension.NS;
      }
      
      public function getElementName() : String
      {
         return WhiteboardExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         getNode().removeNode();
         var _loc2_:XMLNode = XMLFactory.createElement(this.getElementName());
         _loc2_.attributes.xmlns = this.getNS();
         var _loc3_:int = 0;
         while(_loc3_ < this.myPaths.length)
         {
            this.myPaths[_loc3_].serialize(_loc2_);
            _loc3_++;
         }
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:XMLNode = null;
         var _loc4_:Path = null;
         setNode(param1);
         this.myPaths = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.nodeName)
            {
               case "path":
                  _loc4_ = new Path();
                  _loc4_.deserialize(_loc3_);
                  this.myPaths.push(_loc4_);
            }
            _loc2_++;
         }
         return true;
      }
      
      public function get paths() : Array
      {
         return this.myPaths;
      }
   }
}

