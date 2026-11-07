package com.riotgames.platform.gameclient.module.rt
{
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTSimpleCommand extends RTNotifier implements ICommand
   {
      
      public function RTSimpleCommand()
      {
         super();
      }
      
      public function execute(param1:INotification) : void
      {
      }
   }
}

