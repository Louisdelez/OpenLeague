package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class InfoDiscoExtension extends DiscoExtension implements IExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco#info";
      
      private var myIdentities:Array;
      
      private var myFeatures:Array;
      
      public function InfoDiscoExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(InfoDiscoExtension);
      }
      
      public function getElementName() : String
      {
         return DiscoExtension.ELEMENT;
      }
      
      public function getNS() : String
      {
         return InfoDiscoExtension.NS;
      }
      
      public function get identities() : Array
      {
         return this.myIdentities;
      }
      
      public function get features() : Array
      {
         return this.myFeatures;
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         if(!super.deserialize(param1))
         {
            return false;
         }
         this.myIdentities = [];
         this.myFeatures = [];
         for each(_loc2_ in getNode().childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case "identity":
                  this.myIdentities.push(_loc2_.attributes);
                  break;
               case "feature":
                  this.myFeatures.push(_loc2_.attributes["var"]);
            }
         }
         return true;
      }
   }
}

