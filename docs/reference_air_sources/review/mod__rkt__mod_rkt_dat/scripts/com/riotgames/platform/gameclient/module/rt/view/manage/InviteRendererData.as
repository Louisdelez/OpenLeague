package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   
   public class InviteRendererData
   {
      
      public var ineligibleReason:String;
      
      public var buddy:Buddy;
      
      public var header:String;
      
      public var eligible:Boolean = true;
      
      public function InviteRendererData()
      {
         super();
      }
   }
}

