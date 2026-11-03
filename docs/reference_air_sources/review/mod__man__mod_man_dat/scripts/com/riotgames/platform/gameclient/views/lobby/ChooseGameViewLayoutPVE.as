package com.riotgames.platform.gameclient.views.lobby
{
   import com.riotgames.platform.gameclient.Models.GameModel;
   
   public class ChooseGameViewLayoutPVE
   {
      
      public static const INTERNAL_NAME:String = "matchmaking_modePVE";
      
      public static const QUEUE_COOP_VS_AI_SR_5v5_INTRO:Number = 31;
      
      public static const QUEUE_COOP_VS_AI_SR_5v5_EASY:Number = 32;
      
      public static const QUEUE_COOP_VS_AI_SR_5v5_MEDIUM:Number = 33;
      
      public static const QUEUE_COOP_VS_AI_SR_1v1_INTRO:Number = 34;
      
      public static const QUEUE_COOP_VS_AI_SR_1v1_EASY:Number = 35;
      
      public static const QUEUE_COOP_VS_AI_SR_1v1_MEDIUM:Number = 36;
      
      public static const QUEUE_NBOTS:Array = [91,92,93,90];
      
      public static const viewLayout:XML = <option name={INTERNAL_NAME} localeKey="game_flow_mm_pve" properties="gameMode">
					<value data={"classic" + GameModel.PVE_SUFFIX} name="pve_classic" localeKey="game_flow_mm_pve_classic">
						<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
							<value data="SummonersRift;1" name="summoners_rift" localeKey="game_flow_common_summoners_rift_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="INTRO" name="intro_mode" localeKey="game_flow_mm_pve_difficulty_intro">
										<!-- SR 1v1 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_1v1_INTRO} partyid={QUEUE_COOP_VS_AI_SR_1v1_INTRO}/>
									</value>
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 1v1 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_1v1_EASY} partyid={QUEUE_COOP_VS_AI_SR_1v1_EASY}/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 1v1 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_1v1_MEDIUM} partyid={QUEUE_COOP_VS_AI_SR_1v1_MEDIUM}/>
									</value>
								</option>
							</value>
							<value data="SummonersRift;2" name="summoners_rift" localeKey="game_flow_common_summoners_rift_2v2">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 2v2 MMvBot-->
										<queue soloid="13" partyid="13"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 2v2 MMvBot-->
										<queue soloid="13" partyid="13"/>
									</value>
								</option>
							</value>
							<value data="SummonersRift;5" name="summoners_rift" localeKey="game_flow_common_summoners_rift">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="INTRO" name="intro_mode" localeKey="game_flow_mm_pve_difficulty_intro">
										<!-- SR 5v5 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_5v5_INTRO} partyid={QUEUE_COOP_VS_AI_SR_5v5_INTRO}/>
									</value>
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 5v5 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_5v5_EASY} partyid={QUEUE_COOP_VS_AI_SR_5v5_EASY}/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 5v5 MMvBot-->
										<queue soloid={QUEUE_COOP_VS_AI_SR_5v5_MEDIUM} partyid={QUEUE_COOP_VS_AI_SR_5v5_MEDIUM}/>
									</value>
								</option>
							</value>
							<value data="TwistedTreeline;1" name="twisted_treeline" localeKey="game_flow_common_twisted_treeline_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- TT 1v1 MMvBot-->
										<queue soloid="50" partyid="50"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- TT 1v1 MMvBot-->
										<queue soloid="50" partyid="50"/>
									</value>
								</option>
							</value>
							<value data="TwistedTreeline;2" name="twisted_treeline" localeKey="game_flow_common_twisted_treeline_2v2">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- TT 2v2 MMvBot-->
										<queue soloid="51" partyid="51"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- TT 2v2 MMvBot-->
										<queue soloid="51" partyid="51"/>
									</value>
								</option>
							</value>
							<value data="TwistedTreeline;3" name="twisted_treeline" localeKey="game_flow_common_twisted_treeline">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- TT 3v3 MMvBot-->
										<queue soloid="52" partyid="52"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- TT 3v3 MMvBot-->
										<queue soloid="52" partyid="52"/>
									</value>
								</option>
							</value>
						</option>
					</value>

					<value data={"dominion" + GameModel
      .PVE_SUFFIX} name="pve_odin" localeKey="game_flow_mm_pve_odin">
						<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
							<value data="CrystalScar;1" name="crystal_scar" localeKey="game_flow_common_crystal_scar_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 1v1 MMvBot-->
										<queue soloid="23" partyid="23"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 1v1 MMvBot-->
										<queue soloid="23" partyid="23"/>
									</value>
								</option>
							</value>
							<value data="CrystalScar;2" name="crystal_scar" localeKey="game_flow_common_crystal_scar_2v2">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 2v2 MMvBot-->
										<queue soloid="24" partyid="24"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 2v2 MMvBot-->
										<queue soloid="24" partyid="24"/>
									</value>
								</option>
							</value>
							<value data="CrystalScar;5" name="crystal_scar" localeKey="game_flow_common_crystal_scar">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 5v5 MMvBot-->
										<queue soloid="25" partyid="25"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 5v5 MMvBot-->
										<queue soloid="25" partyid="25"/>
									</value>
								</option>
							</value>
						</option>
					</value>

					<value data={"aram" + GameModel
      .PVE_SUFFIX} name="pve_aram" localeKey="game_flow_mm_pve_aram">
						<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
							<value data="ProvingGroundsARAM;1" name="pve_aram" localeKey="game_flow_common_proving_ground_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="EASY" name="easy_mode" localeKey="game_flow_mm_pve_difficulty_easy">
										<!-- SR 1v1 MMvBot-->
										<queue soloid="67" partyid="67"/>
									</value>
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<!-- SR 1v1 MMvBot-->
										<queue soloid="67" partyid="67"/>
									</value>
								</option>
							</value>
						</option>
					</value>

					<value data={"featured_urf" + GameModel.PVE_SUFFIX} name="featured_urf" localeKey="game_flow_mm_pvp_featured_urf" gameKey="urf">
						<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
							<value data="SummonersRift;1" name="featured_cof" localeKey="game_flow_featured_urf_summoners_rift_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<queue soloid="84" partyid="-1"/>
									</value>
								</option>
							</value>
							<value data="SummonersRift;5" name="featured_urf" localeKey="game_flow_featured_urf_summoners_rift_5v5">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="MEDIUM" name="medium_mode" localeKey="game_flow_mm_pve_difficulty_medium">
										<queue soloid="83" partyid="83"/>
									</value>
								</option>
							</value>
						</option>
					</value>

					<value data={"featured_nbots" + GameModel
      .PVE_SUFFIX} name="featured_nbots" localeKey="game_flow_mm_pvp_featured_nbots" gameKey="nbots">
						<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
							<value data="SummonersRift;1" name="featured_nbots" localeKey="game_flow_featured_nbots_summoners_rift_1v1">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="HARD" name="hard_mode" localeKey="game_flow_mm_pve_difficulty_hard">
										<queue soloid="90" partyid="-1"/>
									</value>
									<value data="HARD" name="hard_mode" localeKey="n_bots_debug">
										<queue soloid="94" partyid="-1"/>
									</value>
								</option>
							</value>
							<value data="SummonersRift;2" name="featured_nbots" localeKey="n_bots_2v2">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="HARD" name="hard_mode" localeKey="n_bots_debug">
										<queue soloid="95" partyid="-1"/>
									</value>
								</option>
							</value>
							<value data="SummonersRift;5" name="featured_nbots" localeKey="game_flow_featured_nbots_summoners_rift_5v5">
								<option name="matchmaking_difficulty" properties="difficulty" localeKey="game_flow_mm_pve_difficulty">
									<value data="HARD" name="hard_mode" localeKey="game_flow_mm_pve_difficulty_hard">
										<queue soloid="91" partyid="91"/>
									</value>
									<value data="HARD" name="hard_mode" localeKey="game_flow_mm_pve_difficulty_hard_2">
										<queue soloid="92" partyid="92" queuePrerequisite="91,92,93"/>
									</value>
									<value data="HARD" name="hard_mode" localeKey="game_flow_mm_pve_difficulty_hard_3">
										<queue soloid="93" partyid="93" queuePrerequisite="92,93"/>
									</value>
								</option>
							</value>
						</option>
					</value>
				</option>;
      
      public function ChooseGameViewLayoutPVE()
      {
         super();
      }
   }
}

