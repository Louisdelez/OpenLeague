package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   
   public class Extension extends XMLStanza
   {
      
      public function Extension(param1:XMLNode = null)
      {
         super();
         getNode().nodeName = IExtension(this).getElementName();
         getNode().attributes.xmlns = IExtension(this).getNS();
         if(exists(param1))
         {
            param1.appendChild(getNode());
         }
      }
      
      public function remove() : void
      {
         getNode().removeNode();
      }
      
      public function toString() : String
      {
         return getNode().toString();
      }
   }
}

