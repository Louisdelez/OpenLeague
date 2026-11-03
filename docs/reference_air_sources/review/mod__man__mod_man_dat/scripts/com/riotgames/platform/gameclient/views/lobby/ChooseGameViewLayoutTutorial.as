package com.riotgames.platform.gameclient.views.lobby
{
   public class ChooseGameViewLayoutTutorial
   {
      
      public static const viewLayout:XML = <option name="tutorial_mode" localeKey="game_flow_tutorial" properties="gameMode">
					<value name="proving_grounds" data="basic_tutorial" localeKey="game_flow_tutorial_basic">
						<command system="tutorials" command="basic_tutorial" enabled="true"/>
					</value>
				</option>;
      
      public function ChooseGameViewLayoutTutorial()
      {
         super();
      }
   }
}

