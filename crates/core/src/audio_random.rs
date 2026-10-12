//! Native CRT random arithmetic used by unweighted Wwise selection in 4.20.
//! Caller owns seed and draw ordering; this does not qualify runtime RNG ownership.
#[derive(Clone,Debug)]
pub struct NativeRandom { state:u32 }
impl NativeRandom {
    pub fn seeded(seed:u32)->Self {Self {state:seed}}
    pub fn state(&self)->u32 {self.state}
    pub fn draw(&mut self)->u16 {
        self.state=self.state.wrapping_mul(214013).wrapping_add(2531011);
        ((self.state>>16)&0x7fff) as u16
    }
    /// Property16 gate B2D240. Absence differs from an explicit100 percent.
    pub fn probability(&mut self,percent:Option<f32>)->Result<bool,&'static str> {
        let Some(percent)=percent else {return Ok(true);};
        if !percent.is_finite() || !(0.0..=100.0).contains(&percent) {return Err("unsupported probability");}
        if percent==0. {return Ok(false);}
        let first=u32::from(self.draw());let second=u32::from(self.draw());
        let ticket=f64::from((first<<15)+second)*(1.0/1073741823.0)*100.0;
        Ok(ticket<=f64::from(percent))
    }
    /// Native B05050 weighted ticket: two successive 15-bit draws.
    pub fn weighted_rank(&mut self,total:std::num::NonZeroU32)->u32 {
        let first=u32::from(self.draw());
        let second=u32::from(self.draw());
        ((first<<15)+second)%total.get()
    }
    /// Rank among eligible candidates, not a raw playlist index.
    pub fn unweighted_rank(&mut self,count:std::num::NonZeroU16)->u16 {
        self.draw()%count.get()
    }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn matches_native_sequences_and_wrapped_states() {
 let mut rng=NativeRandom::seeded(0);
 for expected in [38, 7719, 21238, 2437, 8855, 11797, 8365, 32285, 10450, 30612, 5853, 28100, 1142, 281, 20537, 15921, 8945, 26285, 2997, 14680, 20976, 31891, 21655, 25906, 18457, 1323, 28881, 2240, 9725, 32278, 2446, 590, 840, 18587, 16907, 21237, 23611, 12617, 12456, 867, 29533, 6878, 28223, 17887, 31597, 20584, 12212, 31111, 7578, 17066, 7629, 29404, 12279, 13505, 24388, 11649, 12329, 7176, 2331, 19264, 22114, 14136, 26928, 1102] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),2219737664);
 let mut rng=NativeRandom::seeded(1);
 for expected in [41, 18467, 6334, 26500, 19169, 15724, 11478, 29358, 26962, 24464, 5705, 28145, 23281, 16827, 9961, 491, 2995, 11942, 4827, 5436, 32391, 14604, 3902, 153, 292, 12382, 17421, 18716, 19718, 19895, 5447, 21726, 14771, 11538, 1869, 19912, 25667, 26299, 17035, 9894, 28703, 23811, 31322, 30333, 17673, 4664, 15141, 7711, 28253, 6868, 25547, 27644, 32662, 32757, 20037, 12859, 8723, 9741, 27529, 778, 12316, 3035, 22190, 1842] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),120733505);
 let mut rng=NativeRandom::seeded(2);
 for expected in [45, 29216, 24198, 17795, 29484, 19650, 14590, 26431, 10705, 18316, 5557, 28189, 12652, 606, 32153, 17829, 29813, 30367, 6658, 28961, 11039, 30085, 18917, 7167, 14895, 23440, 5962, 2424, 29711, 7512, 8448, 10095, 28702, 4489, 19599, 18588, 27723, 7212, 21614, 18921, 27874, 7976, 1654, 10012, 3749, 21512, 18071, 17079, 16159, 29438, 10698, 25884, 20277, 19240, 15686, 14069, 5118, 12307, 19959, 15059, 2517, 24702, 17452, 2581] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),2316696642);
 let mut rng=NativeRandom::seeded(17);
 for expected in [94, 26602, 30017, 18297, 20363, 13015, 28509, 15290, 29003, 24399, 3339, 28849, 17055, 19424, 4588, 15756, 6098, 11834, 1351, 21383, 18431, 155, 14763, 14082, 4564, 25482, 30678, 20183, 15765, 18376, 20694, 32234, 8292, 29828, 23406, 31490, 25791, 15822, 24763, 23255, 15434, 32590, 15383, 108, 24271, 12086, 29246, 26526, 31363, 7541, 17328, 32253, 31115, 13102, 15958, 32220, 16574, 18024, 4711, 32676, 19373, 22023, 11917, 13678] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),896405329);
 let mut rng=NativeRandom::seeded(32767);
 for expected in [8737, 10287, 8992, 21422, 17363, 31787, 20031, 26205, 13281, 1773, 9076, 29585, 7698, 27187, 3667, 1559, 14669, 15192, 24736, 13116, 26111, 14374, 971, 5692, 3005, 15853, 25527, 8189, 31275, 14033, 30399, 3837, 20764, 29032, 1787, 9097, 13306, 5765, 8383, 25649, 19561, 12622, 19045, 1656, 24615, 32149, 26957, 20432, 32310, 28773, 30753, 709, 1854, 11994, 29278, 11384, 5421, 26422, 6416, 26191, 1568, 16434, 29917, 24555] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),3756737855);
 let mut rng=NativeRandom::seeded(65535);
 for expected in [17440, 23604, 14611, 31702, 3417, 22935, 2042, 17198, 32623, 32321, 12150, 31113, 3624, 5104, 8990, 4536, 14444, 22525, 15539, 2308, 9893, 12339, 28069, 25261, 2156, 8673, 10713, 30614, 30049, 16174, 28586, 28222, 21850, 32429, 4398, 28402, 5057, 12593, 8890, 26689, 8759, 2531, 12968, 30641, 3709, 27793, 11863, 19120, 12181, 30281, 6260, 3021, 11812, 29735, 29816, 12328, 27675, 15467, 2930, 14631, 3990, 7630, 28167, 15979] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),3194733887);
 let mut rng=NativeRandom::seeded(305419896);
 for expected in [13289, 23359, 19469, 24737, 23446, 14229, 6193, 18180, 32073, 13357, 23710, 11617, 2179, 19407, 3337, 19567, 22444, 8594, 26939, 10655, 19464, 32000, 6317, 5209, 26088, 20853, 9302, 2185, 11549, 21704, 17089, 6746, 32178, 26925, 10850, 20289, 3291, 24154, 24106, 2110, 14888, 19945, 10329, 24927, 254, 5886, 14228, 10885, 7752, 15657, 4663, 23914, 15978, 11918, 21484, 13539, 18294, 13635, 27005, 18787, 5027, 6137, 16102, 22209] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),3603001528);
 let mut rng=NativeRandom::seeded(2147483647);
 for expected in [35, 29739, 3374, 11141, 31308, 7870, 5253, 2445, 26706, 3992, 6001, 28056, 11771, 16503, 31113, 31351, 14895, 7860, 1166, 23923, 9560, 16410, 6640, 18892, 3855, 23032, 7572, 18533, 32500, 11893, 32213, 12221, 19677, 25636, 31945, 22561, 21556, 31704, 7877, 24608, 30362, 22714, 25123, 5440, 12752, 3736, 9282, 21743, 19672, 27264, 22479, 31164, 24663, 27022, 28739, 10439, 15934, 4610, 9901, 4982, 31913, 25237, 31666, 362] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),2171258175);
 let mut rng=NativeRandom::seeded(2147483648);
 for expected in [38, 7719, 21238, 2437, 8855, 11797, 8365, 32285, 10450, 30612, 5853, 28100, 1142, 281, 20537, 15921, 8945, 26285, 2997, 14680, 20976, 31891, 21655, 25906, 18457, 1323, 28881, 2240, 9725, 32278, 2446, 590, 840, 18587, 16907, 21237, 23611, 12617, 12456, 867, 29533, 6878, 28223, 17887, 31597, 20584, 12212, 31111, 7578, 17066, 7629, 29404, 12279, 13505, 24388, 11649, 12329, 7176, 2331, 19264, 22114, 14136, 26928, 1102] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),72254016);
 let mut rng=NativeRandom::seeded(4294967295);
 for expected in [35, 29739, 3374, 11141, 31308, 7870, 5253, 2445, 26706, 3992, 6001, 28056, 11771, 16503, 31113, 31351, 14895, 7860, 1166, 23923, 9560, 16410, 6640, 18892, 3855, 23032, 7572, 18533, 32500, 11893, 32213, 12221, 19677, 25636, 31945, 22561, 21556, 31704, 7877, 24608, 30362, 22714, 25123, 5440, 12752, 3736, 9282, 21743, 19672, 27264, 22479, 31164, 24663, 27022, 28739, 10439, 15934, 4610, 9901, 4982, 31913, 25237, 31666, 362] {assert_eq!(rng.draw(),expected);}
 assert_eq!(rng.state(),23774527);
 }
 #[test] fn matches_native_candidate_modulo() {
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(1).unwrap()),0);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(2).unwrap()),0);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(3).unwrap()),2);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(7).unwrap()),3);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(31).unwrap()),7);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(32767).unwrap()),38);
 assert_eq!(NativeRandom::seeded(0).unweighted_rank(std::num::NonZeroU16::new(65535).unwrap()),38);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(1).unwrap()),0);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(2).unwrap()),1);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(3).unwrap()),2);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(7).unwrap()),6);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(31).unwrap()),10);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(32767).unwrap()),41);
 assert_eq!(NativeRandom::seeded(1).unweighted_rank(std::num::NonZeroU16::new(65535).unwrap()),41);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(1).unwrap()),0);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(2).unwrap()),0);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(3).unwrap()),1);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(7).unwrap()),3);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(31).unwrap()),1);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(32767).unwrap()),94);
 assert_eq!(NativeRandom::seeded(17).unweighted_rank(std::num::NonZeroU16::new(65535).unwrap()),94);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(1).unwrap()),0);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(2).unwrap()),1);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(3).unwrap()),2);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(7).unwrap()),0);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(31).unwrap()),4);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(32767).unwrap()),35);
 assert_eq!(NativeRandom::seeded(4294967295).unweighted_rank(std::num::NonZeroU16::new(65535).unwrap()),35);
 }
 #[test] fn matches_native_weighted_tickets_and_two_draw_consumption() {
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1).unwrap()),0); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(2).unwrap()),1); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(3).unwrap()),1); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(100).unwrap()),3); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(65535).unwrap()),7738); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1000000).unwrap()),252903); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(0); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(4294967295).unwrap()),1252903); assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1).unwrap()),0); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(2).unwrap()),1); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(3).unwrap()),0); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(100).unwrap()),55); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(65535).unwrap()),51255); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1000000).unwrap()),361955); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(1); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(4294967295).unwrap()),1361955); assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1).unwrap()),0); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(2).unwrap()),0); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(3).unwrap()),0); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(100).unwrap()),94); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(65535).unwrap()),26649); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1000000).unwrap()),106794); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(17); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(4294967295).unwrap()),3106794); assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1).unwrap()),0); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(2).unwrap()),1); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(3).unwrap()),1); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(100).unwrap()),19); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(65535).unwrap()),62524); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(1000000).unwrap()),176619); assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(4294967295); assert_eq!(rng.weighted_rank(std::num::NonZeroU32::new(4294967295).unwrap()),1176619); assert_eq!(rng.state(),1948984945);
 }
 #[test] fn native_probability_preserves_absent_property_and_draw_order() {
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),0);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),1);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),2);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),17);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),32767);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),65535);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),305419896);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),2147483647);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),2147483648);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(None),Ok(true));assert_eq!(rng.state(),4294967295);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),0);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),1);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),2);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),17);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),32767);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),65535);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),305419896);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),2147483647);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),2147483648);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(0.0f32)),Ok(false));assert_eq!(rng.state(),4294967295);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),1914723980);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),2821695089);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),3694405233);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),1530878130);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),4096468593);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),2653392506);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(0.001f32)),Ok(false));assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),1914723980);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(25.0f32)),Ok(false));assert_eq!(rng.state(),2821695089);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(25.0f32)),Ok(false));assert_eq!(rng.state(),3694405233);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(25.0f32)),Ok(false));assert_eq!(rng.state(),1530878130);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),4096468593);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),2653392506);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(25.0f32)),Ok(true));assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),1914723980);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),2821695089);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(50.0f32)),Ok(false));assert_eq!(rng.state(),3694405233);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),1530878130);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),4096468593);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),2653392506);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(50.0f32)),Ok(true));assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),1914723980);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),2821695089);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),3694405233);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),1530878130);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),4096468593);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),2653392506);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(99.999f32)),Ok(true));assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(0);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),505908858);
 let mut rng=NativeRandom::seeded(1);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),3357800067);
 let mut rng=NativeRandom::seeded(2);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),1914723980);
 let mut rng=NativeRandom::seeded(17);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),1743419155);
 let mut rng=NativeRandom::seeded(32767);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),2821695089);
 let mut rng=NativeRandom::seeded(65535);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),3694405233);
 let mut rng=NativeRandom::seeded(305419896);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),1530878130);
 let mut rng=NativeRandom::seeded(2147483647);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),4096468593);
 let mut rng=NativeRandom::seeded(2147483648);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),2653392506);
 let mut rng=NativeRandom::seeded(4294967295);assert_eq!(rng.probability(Some(100.0f32)),Ok(true));assert_eq!(rng.state(),1948984945);
 let mut rng=NativeRandom::seeded(17);assert!(rng.probability(Some(f32::NAN)).is_err());assert_eq!(rng.state(),17);
 }
}
