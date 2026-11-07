package com.riotgames.platform.gameclient.module.rt.view.header
{
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.rust.components.FlashFlexComponent;
   
   public class ProfileHeaderBG extends FlashFlexComponent
   {
      
      public function ProfileHeaderBG()
      {
         super(RTFacade.context,"rt.HeaderBarBG");
      }
   }
}

