# Muscle Memory: Fit Happens

<img width="512" height="512" alt="image" src="https://github.com/user-attachments/assets/43067f47-cc83-4cd4-a860-e859bce5a31b" />

What the Fit???

## Inspiration
The inspiration for Muscle Memory came from a simple question: "What if logging your workouts felt more like playing a game?"

Drawing inspiration from virtual pet games like Tamagotchi and the progression systems found in role playing video games, we wanted to create something that would turn the sometimes monotonous task of tracking fitness progress into an adventure. The idea was to make your real-world gym sessions directly translate into in-game power, creating a tangible connection between your physical achievements and your digital companion's growth.

## What it does
Muscle Memory is a gamified fitness tracker built with LÖVE2D that transforms your workout routine into an RPG-style adventure.

Players choose from four unique animal companions (Hyrax, Squirrel, Giant Ape, or Lizard), each with distinct visual designs rendered entirely through code using geometric shapes.

The game features a leveling system where your character's level is calculated based on actual workout data. This means every rep you do and every pound you lift directly increases your power.

The dungeon challenge system allows players to face 10 progressively difficult bosses, each with unique designs and escalating difficulty curves. Boss levels range from 10 (Iron Golem) to 1,000 (Eternal Overlord), with health and attack power scaling.

## How we built it
We created the project using the LÖVE2D, a Lua-based framework. Every visual element is drawn programmatically using shapes.

We implemented a State Machine pattern in order to make the logic separated and the program maintainable. We built a particle system and screen shake functionality to provide satisfying feedback.

Every visual element is code-based. For example, the Fire Dragon boss is drawn with procedural code creating ellipses, polygons, and circles to form wings, body, horns, and glowing eyes. This approach kept the project lightweight.

## Challenges we ran into
Balancing Game Progression: The biggest challenge was creating a leveling system that felt rewarding but not exploitable. Early iterations allowed players to level up too quickly by logging hundreds of low-weight reps.

## Accomplishments that we're proud of
The entire game runs without a single image file. Every visual, from the adorable Hyrax to the menacing Eternal Overlord, is rendered through programmatic shapes. We implemented particle effects for every interaction and screen shake for impacts. These details make the app feel responsive and alive.

## What we learned
We learned Lua.

## What's next for Muscle Memory - Fit Happens
Social Features:
- Export trading cards as PNG images for sharing on social media.
- Leaderboards comparing badge collection and highest character levels.
- Friend challenges where you can battle each other's characters.
- Allow players to unlock cosmetic items for their animal companions as they hit milestones.
- Co-op boss battles where you and friends combine your real workout stats to tackle ultra-difficult raid bosses.
- Connect with fitness wearables to automatically log workouts, reducing friction and enabling features like step-count bonuses or heart-rate-based combat mechanics.
