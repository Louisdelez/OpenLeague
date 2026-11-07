package com.riotgames.platform.gameclient.views.lobby
{
   public class ChooseGameFlowViewLayoutDefinition
   {
      
      public static const DYNAMIC_CONFIG_NEW_PLAYER_ROUTER:String = "NewPlayerRouter";
      
      private static var _viewLayoutDefinition:XML = <root>
					<main name="PVP_root">{ChooseGameViewLayoutPVP.viewLayout}</main>

                    <main name="PVE_root">{ChooseGameViewLayoutPVE.viewLayout}</main>

					<main name="custom_root">{ChooseGameViewLayoutCustom.viewLayout}</main>

					<main name="tutorial_root">{ChooseGameViewLayoutTutorial.viewLayout}</main>
				</root>;
      
      public function ChooseGameFlowViewLayoutDefinition()
      {
         super();
      }
      
      public static function get viewLayoutDefinition() : XML
      {
         return _viewLayoutDefinition;
      }
   }
}

