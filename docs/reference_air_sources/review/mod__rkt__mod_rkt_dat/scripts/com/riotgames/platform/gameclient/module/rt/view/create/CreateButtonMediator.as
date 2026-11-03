package com.riotgames.platform.gameclient.module.rt.view.create
{
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import flash.events.MouseEvent;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class CreateButtonMediator extends Mediator
   {
      
      public static var NAME:String = "CreateButtonMediator";
      
      public function CreateButtonMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         this.view.view.addEventListener(MouseEvent.CLICK,this.onCreateTeamClicked);
      }
      
      public function get view() : CreateButton
      {
         return viewComponent as CreateButton;
      }
      
      private function onCreateTeamClicked(param1:MouseEvent) : void
      {
         RTFacade.modalMediator.showCreateTeamModal();
      }
   }
}

