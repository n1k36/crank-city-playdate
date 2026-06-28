-- ============================================================
--  CRANK CITY campaign — street-voice scripts.
--  Types: drive | foot | port | sonar | safe | chase
--  pre = briefing (who gives the job + what to do, slangy)
--  post = the aftermath beat (story lands, characters talk)
-- ============================================================
MISSIONS = {
  -- ACT I -----------------------------------------------------
  { type = "drive", title = "Cold Start", dest = { x = 560, y = -120 },
    pre = {
      { who = "MERIDIAN", port = "rye", txt = "Meridian. Helix put every lock, ride and bank online so they can watch it all." },
      { who = "MERIDIAN", port = "rye", txt = "Only way to move ghost is the old way - by hand. By crank." },
      { who = "Rye", port = "rye", txt = "I'm Rye. Best wheel in the city. And I owe the wrong dude." },
      { who = "HOW TO PLAY", port = "rye", txt = "D-pad drives. Get to the (!) marker. Crank opens safes. Don't get clocked." },
      { who = "Viktor", port = "viktor", txt = "Rye. You owe me, kid. Tonight you start workin' it off." },
      { who = "Viktor", port = "viktor", txt = "Take the ride. Garage on Mercer - that's your marker. Keep it quiet." },
      { who = "Rye", port = "rye", txt = "Drivin' quiet's my whole thing, old man. Watch." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Garage. On time, no scratches. Try not to look so shook." },
      { who = "Viktor", port = "viktor", txt = "Not shook. Careful. You drive like a man with nothin' left to lose." },
      { who = "Rye", port = "rye", txt = "'Cause I don't. You saw to that." },
      { who = "Viktor", port = "viktor", txt = "There's a box in the back. Pop it and we're one night closer to square." },
    } },

  { type = "safe", title = "Pop The Box",
    pre = {
      { who = "Viktor", port = "viktor", txt = "Old analog box. No wires, no signal. Just steel and patience." },
      { who = "HOW TO PLAY", port = "rye", txt = "Crank the dial to each number, then tap A to lock it. Watch the FEEL bar." },
      { who = "Rye", port = "rye", txt = "Elena taught me on a box nastier than this. Gimme a sec." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Three clicks, one breath, open. ...Viktor, this ain't cash." },
      { who = "Rye", port = "rye", txt = "It's a Helix contract. Your name's on it. They own a piece of you, man." },
      { who = "Viktor", port = "viktor", txt = "Everybody in this town owes somebody. Even me. Shut it and forget the name." },
      { who = "Rye", port = "rye", txt = "Kinda hard to forget when it's stamped on my boss." },
    } },

  { type = "chase", title = "Heat",
    pre = {
      { who = "Rye", port = "rye", txt = "That siren? Helix alarm. Blueline's already rollin' on us." },
      { who = "HOW TO PLAY", port = "rye", txt = "Floor it to the (H) hideout. Shake the cops - don't let 'em box you in." },
      { who = "Viktor", port = "viktor", txt = "Then drive, kid. Hideout's past the canal. Don't lead 'em to my door." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Lost 'em at the canal. They were sittin' there waitin', Viktor. They knew." },
      { who = "Viktor", port = "viktor", txt = "Coincidence." },
      { who = "Rye", port = "rye", txt = "You don't buy those. Neither do I." },
      { who = "Viktor", port = "viktor", txt = "Get some sleep. Somebody wants to meet you. Says you're wasted on me." },
    } },

  -- ACT II ----------------------------------------------------
  { type = "port", title = "The Docks", collect = 4,
    pre = {
      { who = "Nyx", port = "nyx", txt = "Four crates came in off the Argent's books. Helix wants 'em gone, quiet." },
      { who = "HOW TO PLAY", port = "rye", txt = "On foot. Grab all 4 crates (follow the #). Patrols don't ask twice - stay off 'em." },
      { who = "Rye", port = "rye", txt = "And you are?" },
      { who = "Nyx", port = "nyx", txt = "The reason your pockets get fat. Move, wheelman." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Four for four. You know this water better than the goons guardin' it." },
      { who = "Nyx", port = "nyx", txt = "Should do. I used to punch a clock for the people who own it." },
      { who = "Rye", port = "rye", txt = "Helix." },
      { who = "Nyx", port = "nyx", txt = "Everybody's got a Helix-shaped scar 'round here. Mine just bites back." },
      { who = "Nyx", port = "nyx", txt = "One crate sank with the boat. I know a diver who owes me." },
    } },

  { type = "sonar", title = "Below The Argent", collect = 3,
    pre = {
      { who = "Mara", port = "mara", txt = "The Argent didn't sink. It got sunk. I know - I was on deck that night." },
      { who = "HOW TO PLAY", port = "rye", txt = "We dive. CRANK aims the sonar - down there you only see what you point at." },
      { who = "Mara", port = "mara", txt = "Grab 3 crates, watch your air, dodge the rocks. Let's get wet." },
    },
    post = {
      { who = "Mara", port = "mara", txt = "Three crates. The rest of the Argent we leave sleepin'. For now." },
      { who = "Rye", port = "rye", txt = "You said you were crew. What'd they make you drop down there?" },
      { who = "Mara", port = "mara", txt = "Didn't ask. That's the part I can't swim away from." },
      { who = "Mara", port = "mara", txt = "Whatever Helix dumped on that wreck, Nyx is payin' big to fish it back." },
    } },

  { type = "drive", title = "Cross Town", dest = { x = -480, y = 420 },
    pre = {
      { who = "Nyx", port = "nyx", txt = "Buyer's uptown. Run the goods over. No scratches, no tails, no drama." },
      { who = "HOW TO PLAY", port = "rye", txt = "Drive to the (!) on the other side of town. Easy money - if you keep it clean." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Dropped. So why's my gut tellin' me to keep the motor runnin'?" },
      { who = "Nyx", port = "nyx", txt = "'Cause you're sharp. The buyer ain't a buyer. He's a vault." },
      { who = "Rye", port = "rye", txt = "Nyx. What're we really liftin' tonight?" },
      { who = "Nyx", port = "nyx", txt = "The truth. Crack his box and see it yourself." },
    } },

  { type = "safe", title = "The Buyer",
    pre = {
      { who = "Nyx", port = "nyx", txt = "Your pay's in his vault. Crack it yourself - trust no clerk, no screen." },
      { who = "HOW TO PLAY", port = "rye", txt = "Same as before: crank to each number, A to lock. Stay smooth." },
      { who = "Rye", port = "rye", txt = "Crack a man's safe in his own crib. Yeah, nothin' ever goes sideways there." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "...This ain't money. These are Helix ledgers. Internal. Buried deep." },
      { who = "Rye", port = "rye", txt = "You didn't hire a crew for a heist, Nyx. You hired us to jack EVIDENCE." },
      { who = "Nyx", port = "nyx", txt = "Evidence that Helix drowned this city to square a balance sheet. You in?" },
      { who = "Rye", port = "rye", txt = "I'm holdin' it. Lil' late to be out." },
      { who = "Nyx", port = "nyx", txt = "Then bounce. Every badge in Meridian just lit up." },
    } },

  { type = "chase", title = "Burned",
    pre = {
      { who = "Viktor", port = "viktor", txt = "Every alarm in the city's screamin' your plate, kid. RUN." },
      { who = "HOW TO PLAY", port = "rye", txt = "Max heat. Get to (H) and lose 'em - the longer you run, the more cops show." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Still breathin'. Barely. Viktor - how'd you know my plate was burned?" },
      { who = "Viktor", port = "viktor", txt = "...'Cause they told me. I've been their hook in you since the debt." },
      { who = "Rye", port = "rye", txt = "The debt was bait." },
      { who = "Viktor", port = "viktor", txt = "It was. I'm sorry, kid. Go find Nyx. Finish it before I gotta pick a side." },
    } },

  -- ACT III ---------------------------------------------------
  { type = "foot", title = "Find Nyx", collect = 3,
    pre = {
      { who = "Rye", port = "rye", txt = "She runs drops through the old market. Follow 'em, find her." },
      { who = "HOW TO PLAY", port = "rye", txt = "On foot - grab her 3 drops (follow the #) to track her down." },
    },
    post = {
      { who = "Nyx", port = "nyx", txt = "You came. And you still got the fragment. Good. I needed someone Helix can't buy." },
      { who = "Rye", port = "rye", txt = "Viktor was theirs the whole time." },
      { who = "Nyx", port = "nyx", txt = "Viktor's a man in a bear trap. We'll see how he chews his way out." },
      { who = "Nyx", port = "nyx", txt = "That ledger's one of three pieces. Two left - a deep vault, and Helix's own tower." },
      { who = "Rye", port = "rye", txt = "So we ain't done. We barely started." },
    },
    ledger = true },

  { type = "sonar", title = "The Deep Vault", collect = 3,
    pre = {
      { who = "Mara", port = "mara", txt = "Piece two's in a data pod, deeper than the Argent. Air gets thin. Stay tight." },
      { who = "HOW TO PLAY", port = "rye", txt = "Crank the sonar, grab 3 crates, surface before your air's gone." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Piece two. Two down, one to go, and no air to spare." },
      { who = "Mara", port = "mara", txt = "Saw the manifest down there, Rye. The night I helped 'em sink it." },
      { who = "Mara", port = "mara", txt = "Wasn't cargo. It was the proof. I been swimmin' over my own guilt for years." },
      { who = "Rye", port = "rye", txt = "Then let's drag it up into the light. All of it." },
    },
    ledger = true },

  { type = "safe", title = "Helix Tower",
    pre = {
      { who = "Elena", port = "elena", txt = "Last piece is in Helix's own vault. Meanest box ever built, kid." },
      { who = "HOW TO PLAY", port = "rye", txt = "Tightest dial yet. Crank slow, feel each click, A to lock." },
      { who = "Elena", port = "elena", txt = "My hands shake now. So I'll talk, you listen, and you open it." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Click three. There it is. Piece three." },
      { who = "Elena", port = "elena", txt = "Taught you on a pawnshop box. Now look - you're crackin' the people who own the city." },
      { who = "Rye", port = "rye", txt = "You taught me the one thing they can't hack. Patience." },
      { who = "Elena", port = "elena", txt = "Now go. Get the whole ledger to Nyx's boat before sunup. Don't look back for me." },
    },
    ledger = true },

  { type = "chase", title = "Dawn Run",
    pre = {
      { who = "Nyx", port = "nyx", txt = "Whole ledger to the boat before the sun's up. Then this city wakes up free." },
      { who = "HOW TO PLAY", port = "rye", txt = "Last run. Max heat, every cop in town. Floor it to (H) and don't stop." },
    },
    post = {
      { who = "Viktor", port = "viktor", txt = "Go, Rye! I'll jam the bridge. Tell 'em an old crook picked the city for once." },
      { who = "Rye", port = "rye", txt = "Sun's up. Helix goes dark. ...We really made it." },
      { who = "Nyx", port = "nyx", txt = "We? Careful, wheelman. That almost sounded like a crew." },
      { who = "Rye", port = "rye", txt = "Don't get used to it. ...A'ight. Maybe get a lil' used to it." },
    },
    ending = true },
}
