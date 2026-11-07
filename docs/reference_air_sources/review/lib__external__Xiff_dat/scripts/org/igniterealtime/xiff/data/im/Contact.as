package org.igniterealtime.xiff.data.im
{
   import mx.core.IPropertyChangeNotifier;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public interface Contact extends IPropertyChangeNotifier
   {
      
      function get jid() : UnescapedJID;
      
      function set jid(param1:UnescapedJID) : void;
      
      function get displayName() : String;
      
      function set displayName(param1:String) : void;
      
      function get show() : String;
      
      function set show(param1:String) : void;
      
      function get online() : Boolean;
      
      function set online(param1:Boolean) : void;
   }
}

