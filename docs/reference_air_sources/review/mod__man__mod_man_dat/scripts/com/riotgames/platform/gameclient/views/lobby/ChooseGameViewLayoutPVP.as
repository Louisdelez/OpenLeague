package com.riotgames.platform.gameclient.views.lobby
{
   public class ChooseGameViewLayoutPVP
   {
      
      public static const INTERNAL_NAME:String = "matchmaking_modePVP";
      
      public static const viewLayout:XML = <option name={INTERNAL_NAME} localeKey="game_flow_mm_pvp" properties="gameMode">
				<value data="classic_pvp" name="pvp_classic" localeKey="game_flow_mm_pvp_classic">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="SummonersRift;1" name="summoners_rift" localeKey="game_flow_common_summoners_rift_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;cap" name="Normal" localeKey="game_flow_mm_pvp_normal_cap">
									<queue soloid="60" partyid="60"/>
								</value>
								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- SR 1v1 Normal Blind -->
									<queue soloid="0" partyid="0"/>
								</value>
								<value data="false;draft_mode" name="Normal" localeKey="game_flow_mm_pvp_normal_draft_queue">
									<!-- SR 1v1 Normal Draft -->
									<queue soloid="30" partyid="30"/>
								</value>
								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_draft_queue">
									<!-- SR 1v1 Ranked Draft -->
									<queue soloid="10" partyid="10"/>
								</value>
							</option>
						</value>
						<value data="SummonersRift;2" name="summoners_rift" localeKey="game_flow_common_summoners_rift_2v2">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- SR 2v2 Normal Blind -->
									<queue soloid="1" partyid="1"/>
								</value>
							</option>
						</value>
						<value data="SummonersRift;5" name="summoners_rift" localeKey="game_flow_common_summoners_rift">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;cap" name="Normal" localeKey="game_flow_mm_pvp_normal_cap">
									<queue soloid="61" partyid="61"/>
								</value>

								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- SR 5v5 Normal Blind -->
									<queue soloid="2" partyid="2"/>
								</value>
                                <value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
                                    <!-- SR 5v5 Normal Blind DEVELOPMENT MAPS -->
                                    <queue soloid="200" partyid="200"/>
                                </value>

								<value data="false;draft_mode" name="Normal" localeKey="game_flow_mm_pvp_normal_draft_queue">
									<!-- SR 5v5 Normal Draft -->
									<queue soloid="14" partyid="14"/>
								</value>
                                <value data="false;draft_mode" name="Normal" localeKey="game_flow_mm_pvp_normal_draft_queue">
                                    <!-- SR 5v5 Normal Draft DEVELOPMENT MAPS -->
                                    <queue soloid="201" partyid="201"/>
                                </value>

								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_duo_queue">
									<!-- SR 5v5 Ranked -->
									<queue soloid="4" partyid="6"/>
								</value>
                                <value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_duo_queue">
                                    <!-- SR 5v5 Ranked DEVELOPMENT MAPS -->
                                    <queue soloid="202" partyid="202"/>
                                </value>

								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_team_queue">
									<!-- SR 5v5 Ranked Team-->
									<queue soloid="-1" partyid="42"/>
								</value>
                                <value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_team_queue">
                                    <!-- SR 5v5 Ranked Team DEVELOPMENT MAPS -->
                                    <queue soloid="-1" partyid="203"/>
                                </value>
							</option>
						</value>
						<value data="TwistedTreeline;3" name="twisted_treeline" localeKey="game_flow_common_twisted_treeline">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- TT 3v3 Normal Blind -->
									<queue soloid="8" partyid="8"/>
								</value>
								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_draft_queue">
									<!-- TT 3v3 Ranked Draft -->
									<queue soloid="11" partyid="9"/>
								</value>
								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_team_queue">
									<!-- TT 3v3 Ranked Team -->
									<queue soloid="-1" partyid="41"/>
								</value>
							</option>
						</value>
					</option>
				</value>
				<value data="odin_pvp" name="pvp_odin" localeKey="game_flow_mm_pvp_odin">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="CrystalScar;1" name="crystal_scar" localeKey="game_flow_common_crystal_scar_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- CC 1v1 Normal Blind -->
									<queue soloid="15" partyid="15"/>
								</value>
							</option>
						</value>
						<value data="CrystalScar;5" name="crystal_scar" localeKey="game_flow_common_crystal_scar">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;blind_pick" name="Normal" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- CC 5v5 Normal Blind -->
									<queue soloid="16" partyid="16"/>
								</value>
								<value data="false;draft_mode" name="Normal" localeKey="game_flow_mm_pvp_normal_draft_queue">
									<!-- CC 5v5 Normal Draft -->
									<queue soloid="17" partyid="17"/>
								</value>
								<value data="true;draft_mode" name="Ranked" localeKey="game_flow_mm_pvp_ranked_draft_queue">
									<!-- CC 5v5 Ranked -->
									<queue soloid="18" partyid="19"/>
								</value>
							</option>
						</value>
					</option>
				</value>
				<value data="aram_pvp" name="freljord_mode" localeKey="game_flow_mm_pvp_aram">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="HowlingAbyss;1" name="freljord_map" localeKey="game_flow_common_howling_abyss_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_random" name="Normal" localeKey="game_flow_mm_pvp_normal_all_random">
									<!-- ARAM 1v1 Normal -->
									<queue soloid="62" partyid="-1"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;2" name="freljord_map" localeKey="game_flow_common_howling_abyss_2v2">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_random" name="Normal" localeKey="game_flow_mm_pvp_normal_all_random">
									<!-- ARAM 2v2 Normal -->
									<queue soloid="63" partyid="63"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;3" name="freljord_map" localeKey="game_flow_common_howling_abyss_3v3">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_random" name="Normal" localeKey="game_flow_mm_pvp_normal_all_random">
									<!-- ARAM 3v3 Normal -->
									<queue soloid="64" partyid="64"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;5" name="freljord_map" localeKey="game_flow_common_howling_abyss_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_random" name="Normal" localeKey="game_flow_mm_pvp_normal_all_random">
									<!-- ARAM 5v5 Normal -->
									<queue soloid="65" partyid="65"/>
								</value>
							</option>
						</value>                                                   `
						<value data="HowlingAbyss;6" name="freljord_map" localeKey="game_flow_common_howling_abyss_6v6">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_random" name="Normal" localeKey="game_flow_mm_pvp_normal_all_random">
									<!-- ARAM 6v6 Normal -->
									<queue soloid="66" partyid="66"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_ofa_pvp" name="featured_ofa" localeKey="game_flow_mm_pvp_featured_ofa" gameKey="ofa">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="SummonersRift;5" name="featured_ofa" localeKey="game_flow_featured_ofa_summoners_rift_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_for_one" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ofa">
									<queue soloid="70" partyid="70"/>
								</value>
							</option>
						</value>
						<value data="SummonersRift;1" name="featured_ofa" localeKey="game_flow_featured_ofa_summoners_rift_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_for_one" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ofa">
									<queue soloid="71" partyid="71"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_ofax_pvp" name="featured_ofax" localeKey="game_flow_mm_pvp_featured_ofax" gameKey="ofax">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="HowlingAbyss;5" name="featured_ofax" localeKey="game_flow_featured_ofax_howling_abyss_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_for_one" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ofax">
									<queue soloid="78" partyid="78"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;2" name="featured_ofax" localeKey="game_flow_featured_ofax_howling_abyss_2v2">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_for_one" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ofax">
									<queue soloid="79" partyid="79"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;1" name="featured_ofax" localeKey="game_flow_featured_ofax_howling_abyss_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;all_for_one" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ofax">
									<queue soloid="80" partyid="80"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_fbl_pvp" name="featured_fbl" localeKey="game_flow_mm_pvp_featured_fbl" gameKey="fbl">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="HowlingAbyss;1" name="featured_fbl" localeKey="game_flow_featured_fbl_howling_abyss_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;first_blood" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_fbl">
									<queue soloid="72" partyid="-1"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;2" name="featured_fbl" localeKey="game_flow_featured_fbl_howling_abyss_2v2">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;first_blood" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_fbl">
									<queue soloid="73" partyid="73"/>
								</value>
							</option>
						</value>
					</option>
				</value>

                <!-- HEXAKILL IS CURRENTLY ON TWISTED TREELINE -->
                <value data="featured_tt6_pvp" name="featured_tt6" localeKey="game_flow_mm_pvp_featured_tt6" gameKey="tt6">
                    <option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
                        <value data="TwistedTreeline;6" name="featured_tt6" localeKey="game_flow_featured_twisted_treeline_6v6">
                            <option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
                                <value data="false;blind_pick" name="featured_tt6" localeKey="game_flow_mm_pvp_normal_featured_tt6">
                                    <queue soloid="98" partyid="98"/>
                                </value>
                            </option>
                        </value>
                    </option>
                </value>
                <!-- IF HEXAKILL IS ON SUMMONER'S RIFT, USE THE FOLLOWING DEFINITION INSTEAD
                <value data="featured_sr6_pvp" name="featured_sr6" localeKey="game_flow_mm_pvp_featured_sr6" gameKey="sr6">
                    <option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
                        <value data="SummonersRift;6" name="featured_sr6" localeKey="game_flow_featured_summoners_rift_6v6">
                            <option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
                                <value data="false;blind_pick" name="featured_sr6" localeKey="game_flow_mm_pvp_normal_featured_sr6">
                                    <queue soloid="75" partyid="75"/>
                                </value>
                            </option>
                        </value>
                    </option>
                </value>
                -->

				<value data="featured_tt5_pvp" name="featured_tt5" localeKey="game_flow_mm_pvp_featured_tt5">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="TwistedTreeline;5" name="twisted_treeline" localeKey="game_flow_featured_twisted_treeline_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;blind_pick" name="featured_tt5" localeKey="game_flow_mm_pvp_normal_blind_queue">
									<!-- TT 5v5 Blind-->
									<queue soloid="74" partyid="74"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_urf_pvp" name="featured_urf" localeKey="game_flow_mm_pvp_featured_urf" gameKey="urf">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="SummonersRift;1" name="featured_urf" localeKey="game_flow_featured_urf_summoners_rift_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;urf" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_urf">
									<queue soloid="77" partyid="-1"/>
								</value>
							</option>
						</value>
						<value data="SummonersRift;5" name="featured_urf" localeKey="game_flow_featured_urf_summoners_rift_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;urf" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_urf">
									<queue soloid="76" partyid="76"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_hy_pvp" name="featured_hy" localeKey="game_flow_mm_pvp_featured_hy">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="SummonersRift;5" name="featured_hy" localeKey="game_flow_featured_hy_summoners_rift_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;hy" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_hy">
									<queue soloid="81" partyid="81"/>
								</value>
							</option>
						</value>
						<value data="SummonersRift;1" name="featured_hy" localeKey="game_flow_featured_hy_summoners_rift_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;hy" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_hy">
									<queue soloid="82" partyid="82"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_asc_pvp" name="featured_asc" localeKey="game_flow_mm_pvp_featured_asc" gameKey="asc">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="CrystalScar;5" name="featured_asc" localeKey="game_flow_featured_asc_crystal_scar_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;asc" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_asc">
									<queue soloid="96" partyid="96"/>
								</value>
							</option>
						</value>
						<value data="CrystalScar;1" name="featured_asc" localeKey="game_flow_featured_asc_crystal_scar_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;asc" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_asc">
									<queue soloid="97" partyid="-1"/>
								</value>
							</option>
						</value>
					</option>
				</value>

				<value data="featured_ppp_pvp" name="featured_ppp" localeKey="game_flow_mm_pvp_featured_ppp" gameKey="ppp">
					<option name="matchmaking_map" properties="gameMap;numPlayersPerTeam" localeKey="game_flow_common_select_map">
						<value data="HowlingAbyss;5" name="featured_ppp" localeKey="game_flow_featured_ppp_howling_abyss_5v5">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;ppp" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ppp">
									<queue soloid="300" partyid="300"/>
								</value>
							</option>
						</value>
						<value data="HowlingAbyss;1" name="featured_ppp" localeKey="game_flow_featured_ppp_howling_abyss_1v1">
							<option name="matchmaking_type" properties="ranked;gameType" localeKey="game_flow_mm_common_type">
								<value data="false;ppp" name="Normal" localeKey="game_flow_mm_pvp_normal_featured_ppp">
									<queue soloid="301" partyid="-1"/>
								</value>
							</option>
						</value>
					</option>
				</value>
			</option>;
      
      public function ChooseGameViewLayoutPVP()
      {
         super();
      }
   }
}

