package com.riotgames.platform.gameclient.views.lobby
{
   public class ChooseGameViewLayoutCustom
   {
      
      public static const viewLayout:XML = <option name="custom_mode" localeKey="game_flow_custom" properties="gameMode">
                    <value name="custom_create" data="custom" localeKey="game_flow_custom_join_slash_create">
                        <command system="custom_games" command="join_slash_create"/>
                    </value>
                    <value name="custom_tournament" data="custom" localeKey="game_flow_custom_tournament_code">
                        <command system="custom_games" command="tournament_code"/>
                    </value>


                    <value name="custom_ofa" data="custom_ofa" localeKey="custom_ofa_game_mode" gameKey="ofa">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <value name="custom_fbl" data="custom_fbl" localeKey="custom_fbl_game_mode" gameKey="fbl">
                        <command system="custom_games" command="featured"/>
                    </value>

                    <!-- HEXAKILL IS CURRENTLY ON TWISTED TREELINE -->
                    <value name="custom_tt6" data="custom_tt6" localeKey="custom_tt6_game_mode" gameKey="tt6">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <!-- IF HEXAKILL IS ON SUMMONER'S RIFT, USE THE FOLLOWING DEFINITION INSTEAD
                    <value name="custom_sr6" data="custom_sr6" localeKey="custom_sr6_game_mode" gameKey="sr6">
                        <command system="custom_games" command="featured"/>
                    </value>
                    -->

                    <value name="custom_ofax" data="custom_ofax" localeKey="custom_ofax_game_mode" gameKey="ofax">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <value name="custom_urf" data="custom_urf" localeKey="custom_urf_game_mode" gameKey="urf">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <value name="custom_tagteam" data="custom_tagteam" localeKey="custom_tagteam_game_mode" gameKey="tagteam">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <value name="custom_asc" data="custom_asc" localeKey="custom_asc_game_mode" gameKey="asc">
                        <command system="custom_games" command="featured"/>
                    </value>
                    <value name="custom_ppp" data="custom_ppp" localeKey="custom_ppp_game_mode" gameKey="ppp">
                        <command system="custom_games" command="featured"/>
                    </value>
                </option>;
      
      public function ChooseGameViewLayoutCustom()
      {
         super();
      }
   }
}

