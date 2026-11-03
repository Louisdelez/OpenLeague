package org.igniterealtime.xiff.bookmark
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class UrlBookmark implements ISerializable
   {
      
      private var node:XMLNode;
      
      public function UrlBookmark(param1:String = null, param2:String = null)
      {
         super();
         if(!param1 && !param2)
         {
            return;
         }
         if(!param1 || !param2)
         {
            throw new Error("Name and url cannot be null, they must either both be null or an Object");
         }
         this.node = new XMLNode(1,"url");
         this.node.attributes.name = param1;
         this.node.attributes.url = param2;
      }
      
      public function get name() : String
      {
         return this.node.attributes.name;
      }
      
      public function get url() : String
      {
         return this.node.attributes.uri;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         param1.appendChild(this.node.cloneNode(true));
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         this.node = param1.cloneNode(true);
         return true;
      }
   }
}

