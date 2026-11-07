package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class MUCAdminExtension extends MUCBaseExtension implements IExtension
   {
      
      public static var NS:String = "http://jabber.org/protocol/muc#admin";
      
      public static var ELEMENT:String = "query";
      
      private var myItems:Array;
      
      public function MUCAdminExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function getNS() : String
      {
         return MUCAdminExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCAdminExtension.ELEMENT;
      }
   }
}

