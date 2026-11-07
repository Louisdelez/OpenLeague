package org.igniterealtime.xiff.core
{
   public class EscapedJID extends AbstractJID
   {
      
      public function EscapedJID(param1:String, param2:Boolean = false)
      {
         super(param1,param2);
         if(Boolean(node))
         {
            _node = escapedNode(node);
         }
      }
      
      public function get unescaped() : UnescapedJID
      {
         return new UnescapedJID(toString());
      }
      
      public function equals(param1:EscapedJID, param2:Boolean) : Boolean
      {
         if(param2)
         {
            return param1.bareJID == bareJID;
         }
         return param1.toString() == toString();
      }
   }
}

