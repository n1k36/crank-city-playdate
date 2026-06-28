-- ============================================================
--  CRANK CITY campaign. Types the engine runs:
--    drive | foot | port | sonar | safe | chase
--  pre/post = cutscene line lists (who, port, txt). Post beats
--  are written long on purpose — the story lands after each job.
-- ============================================================
MISSIONS = {
  -- ACT I -----------------------------------------------------
  { type = "drive", title = "Cold Start", dest = { x = 560, y = -120 },
    pre = {
      { who = "Viktor", port = "viktor", txt = "Rye. You owe me. Tonight you start paying it down." },
      { who = "Viktor", port = "viktor", txt = "Take the car. Garage on Mercer. Don't be seen." },
      { who = "Rye", port = "rye", txt = "Driving I can do. It's the 'don't be seen' part that costs extra." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Garage. On time. Try not to look so surprised, Viktor." },
      { who = "Viktor", port = "viktor", txt = "Surprised? No. Careful. You drive like a man with nothing to lose." },
      { who = "Rye", port = "rye", txt = "That's because I don't. You made sure of that." },
      { who = "Viktor", port = "viktor", txt = "...There's a box in the back. Open it and we're one night closer to even." },
    } },

  { type = "safe", title = "Open It",
    pre = {
      { who = "Viktor", port = "viktor", txt = "Old analog box. No serial, no signal. Just steel and patience." },
      { who = "Rye", port = "rye", txt = "Elena taught me on one meaner than this. Give me a minute." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Three tumblers, one breath. Open. ...Viktor, this isn't cash." },
      { who = "Rye", port = "rye", txt = "It's a Helix contract. Your name's on it. They own a piece of you." },
      { who = "Viktor", port = "viktor", txt = "Everybody in Meridian owes somebody. Even me. Close it and forget the name." },
      { who = "Rye", port = "rye", txt = "Hard to forget a name when it's stamped on my boss." },
    } },

  { type = "chase", title = "Blueline",
    pre = {
      { who = "Rye", port = "rye", txt = "That tone — that's a Helix alarm. Blueline's already rolling." },
      { who = "Viktor", port = "viktor", txt = "Then lose them, kid. Hideout's south of the canal. Don't lead them home." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Lost them at the canal. They were waiting for us, Viktor. They knew." },
      { who = "Viktor", port = "viktor", txt = "Coincidence." },
      { who = "Rye", port = "rye", txt = "You don't believe in those. Neither do I." },
      { who = "Viktor", port = "viktor", txt = "Get some sleep. Someone wants to meet you. Says you're wasted on me." },
    } },

  -- ACT II ----------------------------------------------------
  { type = "port", title = "The Docks", collect = 4,
    pre = {
      { who = "Nyx", port = "nyx", txt = "Four crates came in off the Argent's manifest. Helix wants them buried." },
      { who = "Nyx", port = "nyx", txt = "Walk the docks. Grab all four. Patrols won't ask twice." },
      { who = "Rye", port = "rye", txt = "And you are?" },
      { who = "Nyx", port = "nyx", txt = "The reason you get paid. Move." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Four for four. You know this water better than the men guarding it." },
      { who = "Nyx", port = "nyx", txt = "I should. I used to work for the people who own it." },
      { who = "Rye", port = "rye", txt = "Helix." },
      { who = "Nyx", port = "nyx", txt = "Everyone in this city has a Helix shape in their past, Rye. Mine just bites back." },
      { who = "Nyx", port = "nyx", txt = "One crate's missing. Went down with the ship. I know a diver." },
    } },

  { type = "sonar", title = "Below the Argent", collect = 3,
    pre = {
      { who = "Mara", port = "mara", txt = "The Argent didn't sink. It was sunk. I know — I was crew that night." },
      { who = "Mara", port = "mara", txt = "Crank aims the sonar. Down there you only get what you choose to see." },
      { who = "Rye", port = "rye", txt = "Comforting. Let's get wet." },
    },
    post = {
      { who = "Mara", port = "mara", txt = "Three crates. The rest of the Argent... we leave sleeping. For now." },
      { who = "Rye", port = "rye", txt = "You said you were crew. What did they make you sink?" },
      { who = "Mara", port = "mara", txt = "I didn't ask. That's the part I can't dive away from." },
      { who = "Mara", port = "mara", txt = "Whatever Helix put on that ship, Nyx is paying a lot to get it back." },
    } },

  { type = "drive", title = "Cross Town", dest = { x = -480, y = 420 },
    pre = { { who = "Nyx", port = "nyx", txt = "Buyer's uptown. Drive the goods. No scratches, no tails." } },
    post = {
      { who = "Rye", port = "rye", txt = "Delivered. So why is my gut telling me to keep the engine running?" },
      { who = "Nyx", port = "nyx", txt = "Because you're smart. The buyer isn't a buyer. He's a vault." },
      { who = "Rye", port = "rye", txt = "Nyx. What are we actually stealing tonight?" },
      { who = "Nyx", port = "nyx", txt = "The truth. Open his safe and you'll see it for yourself." },
    } },

  { type = "safe", title = "The Buyer",
    pre = {
      { who = "Nyx", port = "nyx", txt = "Payment's in his vault. Crack it yourself. Trust no clerk, no screen." },
      { who = "Rye", port = "rye", txt = "Crack a man's safe in his own house. Nothing ever goes wrong there." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "...This isn't money. These are Helix ledgers. Internal. Buried." },
      { who = "Rye", port = "rye", txt = "You didn't hire a crew for a heist, Nyx. You hired us to steal EVIDENCE." },
      { who = "Nyx", port = "nyx", txt = "Evidence that Helix drowned this city to balance a book. You in or out?" },
      { who = "Rye", port = "rye", txt = "I'm holding it. A little late to be out." },
      { who = "Nyx", port = "nyx", txt = "Then run. Every badge in Meridian just woke up." },
    } },

  { type = "chase", title = "Burned",
    pre = { { who = "Viktor", port = "viktor", txt = "Every alarm in the city is screaming your plate. RUN, Rye." } },
    post = {
      { who = "Rye", port = "rye", txt = "Still breathing. Barely. Viktor — how did you know my plate was burned?" },
      { who = "Viktor", port = "viktor", txt = "...Because they told me. I've been their hook in you since the debt." },
      { who = "Rye", port = "rye", txt = "The debt was bait." },
      { who = "Viktor", port = "viktor", txt = "It was. I'm sorry, kid. Find Nyx. Finish it before I have to choose a side." },
    } },

  -- ACT III ---------------------------------------------------
  { type = "foot", title = "Find Nyx", collect = 3,
    pre = { { who = "Rye", port = "rye", txt = "She runs drops through the old market. Follow them, find her." } },
    post = {
      { who = "Nyx", port = "nyx", txt = "You came. And you still have the fragment. Good. I needed someone Helix couldn't buy." },
      { who = "Rye", port = "rye", txt = "Viktor was theirs the whole time." },
      { who = "Nyx", port = "nyx", txt = "Viktor's a man in a trap. We'll see which way he chews his leg off." },
      { who = "Nyx", port = "nyx", txt = "That ledger is one of three fragments. Two more — a deep vault, and Helix's own tower." },
      { who = "Rye", port = "rye", txt = "Then we're not done. We're barely started." },
    },
    ledger = true },

  { type = "sonar", title = "The Deep Vault", collect = 3,
    pre = { { who = "Mara", port = "mara", txt = "Fragment two is in a data pod, deeper than the Argent. Air gets thin. Stay sharp." } },
    post = {
      { who = "Rye", port = "rye", txt = "Fragment two. Two down, one to go, and no air to spare." },
      { who = "Mara", port = "mara", txt = "I saw the manifest down there, Rye. The night I helped them sink it." },
      { who = "Mara", port = "mara", txt = "It wasn't cargo. It was the proof. I've been swimming over my own guilt for years." },
      { who = "Rye", port = "rye", txt = "Then let's drag it into the daylight. All of it." },
    },
    ledger = true },

  { type = "safe", title = "Helix Tower",
    pre = {
      { who = "Elena", port = "elena", txt = "The last fragment's in Helix's own vault. The hardest box ever built." },
      { who = "Elena", port = "elena", txt = "My hands shake now, Rye. So I'll talk, and you'll listen, and you'll open it." },
    },
    post = {
      { who = "Rye", port = "rye", txt = "Tumbler three. There it is. Fragment three." },
      { who = "Elena", port = "elena", txt = "I taught you on a pawnshop box. Look at you now. Cracking the people who own the city." },
      { who = "Rye", port = "rye", txt = "You taught me the only thing they can't hack — patience." },
      { who = "Elena", port = "elena", txt = "Go. Get the whole ledger to Nyx's boat before sunrise. Don't look back for me." },
    },
    ledger = true },

  { type = "chase", title = "Dawn Run",
    pre = { { who = "Nyx", port = "nyx", txt = "Full ledger to the boat before the sun's up. Then Meridian wakes up free." } },
    post = {
      { who = "Viktor", port = "viktor", txt = "Go, Rye! I'll hold the bridge. Tell them an old crook chose the city for once." },
      { who = "Rye", port = "rye", txt = "Sun's up. Helix goes dark. ...We really made it." },
      { who = "Nyx", port = "nyx", txt = "We? Careful, wheelman. That almost sounded like a crew." },
      { who = "Rye", port = "rye", txt = "Don't get used to it. ...Okay. Maybe get a little used to it." },
    },
    ending = true },
}
