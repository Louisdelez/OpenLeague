package org.igniterealtime.xiff.conference
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   import org.igniterealtime.xiff.events.InviteEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   
   [Event(name="invited",type="org.igniterealtime.xiff.events.InviteEvent")]
   public class InviteListener extends EventDispatcher
   {
      
      private var myConnection:XMPPConnection;
      
      public function InviteListener(param1:XMPPConnection = null)
      {
         super();
         if(param1 != null)
         {
            this.setConnection(param1);
         }
      }
      
      public function setConnection(param1:XMPPConnection) : void
      {
         if(this.myConnection != null)
         {
            this.myConnection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
         }
         this.myConnection = param1;
         this.myConnection.addEventListener(MessageEvent.MESSAGE,this.handleEvent);
      }
      
      public function getConnection() : XMPPConnection
      {
         return this.myConnection;
      }
      
      private function handleEvent(param1:Object) : void
      {
         var msg:Message = null;
         var exts:Array = null;
         var muc:MUCUserExtension = null;
         var room:Room = null;
         var e:InviteEvent = null;
         var eventObj:Object = param1;
         switch(eventObj.type)
         {
            case MessageEvent.MESSAGE:
               try
               {
                  msg = eventObj.data as Message;
                  exts = msg.getAllExtensionsByNS(MUCUserExtension.NS);
                  if(!exts || exts.length < 0)
                  {
                     return;
                  }
                  muc = exts[0];
                  if(muc.type == MUCUserExtension.INVITE_TYPE)
                  {
                     room = new Room(this.myConnection);
                     room.roomJID = msg.from.unescaped;
                     room.password = muc.password;
                     e = new InviteEvent();
                     e.from = muc.from.unescaped;
                     e.reason = muc.reason;
                     e.room = room;
                     e.data = msg;
                     dispatchEvent(e);
                  }
               }
               catch(e:Error)
               {
               }
         }
      }
   }
}

