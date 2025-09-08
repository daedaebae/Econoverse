<!-- Economy_System.md -->
<!-- TODO: Rework overview to show how goods flow into the kingdom inlcuding
to/from the player. -->

### Economy System

#### Overview

This is the general overview of how commodities flow through the kingdom.

#### DRAFT - Ideation - Kingdom Economy

![Kingdom Economy](mermaid)
```mermaid
graph TB
    subgraph Kingdom Economy
    direction TB
    subgraph Commodities
        Metals[Metals]
        Alcohol[Alcohol]
        Horses[Horses]
        Food[Food]
    end

    subgraph Shops
        Blacksmith[Blacksmith] --> Metals
        Brewer[Brewer] --> Alcohol
        Stablemaster[Stablemaster] --> Horses
        Baker[Baker] --> Food
    end
end
```