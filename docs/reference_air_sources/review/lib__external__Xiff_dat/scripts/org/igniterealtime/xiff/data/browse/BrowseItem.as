package org.igniterealtime.xiff.data.browse
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class BrowseItem extends XMLStanza implements ISerializable
   {
      
      public function BrowseItem(param1:XMLNode)
      {
         super();
         getNode().nodeName = "item";
         if(exists(param1))
         {
            param1.appendChild(getNode());
         }
      }
      
      public function get jid() : String
      {
         return getNode().attributes.jid;
      }
      
      public function set jid(param1:String) : void
      {
         getNode().attributes.jid = param1;
      }
      
      public function get category() : String
      {
         return getNode().attributes.category;
      }
      
      public function set category(param1:String) : void
      {
         getNode().attributes.category = param1;
      }
      
      public function get name() : String
      {
         return getNode().attributes.name;
      }
      
      public function set name(param1:String) : void
      {
         getNode().attributes.name = param1;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(param1:String) : void
      {
         getNode().attributes.type = param1;
      }
      
      public function get version() : String
      {
         return getNode().attributes.version;
      }
      
      public function set version(param1:String) : void
      {
         getNode().attributes.version = param1;
      }
      
      public function addNamespace(param1:String) : XMLNode
      {
         return addTextNode(getNode(),"ns",param1);
      }
      
      public function get namespaces() : Array
      {
         var _loc2_:XMLNode = null;
         var _loc1_:Array = [];
         for each(_loc2_ in getNode().childNodes)
         {
            if(_loc2_.nodeName == "ns")
            {
               _loc1_.push(_loc2_.firstChild.nodeValue);
            }
         }
         return _loc1_;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = getNode();
         if(!exists(_loc2_.parentNode))
         {
            param1.appendChild(_loc2_.cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         setNode(param1);
         return true;
      }
   }
}

