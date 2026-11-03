package org.igniterealtime.xiff.data.sharedgroups
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class SharedGroupsExtension implements IExtension, ISerializable
   {
      
      public function SharedGroupsExtension()
      {
         super();
      }
      
      public function getNS() : String
      {
         return "http://www.jivesoftware.org/protocol/sharedgroup";
      }
      
      public function getElementName() : String
      {
         return "sharedgroup";
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = new XMLNode(1,this.getElementName() + " xmlns=\'" + this.getNS() + "\'");
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         return true;
      }
   }
}

