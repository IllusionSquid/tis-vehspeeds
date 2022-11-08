# Documentation

## tis-vehspeeds
A script that adds a command to "train" a car to have the correct 0-60 speeds. It spits out the correct fInitialDriveForce in the console, so you will just need to add that to your `handling.meta`. It is advised to check the speeds of your car in the high speed range. If it doesn't reach the desired speed, adjust the `fInitialDragCoeff` accordingly.

Another command is added (`speedtest` for single vehicle `speedtestlist` for the list saved in `config.lua`), it will perform an automated test on your vehicle that gets the following info:
- 0-60 mph speed
- 0-100 mph speed
- 0.25 mile time
- 0.25 mile speed
- 0.5 mile time
- 0.5 mile speed
- 1 mile time
- 1 mile speed 

This also adds a database table where the results of speed tests are saved.

## Plans
- Create UI to view the speeds

## Dependencies
- **[qb-core](https://github.com/qbcore-framework/qb-core)** (for adding commands, can be replaced with natives if you want to use this standalone)

## Installation
1. Download .zip file
2. Open the .zip file
3. Drop the folder `tis-vehspeeds-master` inside recourse folder
4. Rename `tis-vehspeeds-master` to `tis-vehspeeds`
5. Add the line `ensure tis-vehspeeds` in your `server.cfg`
8. Don't forget to run the `tis-vehspeeds.sql` on your database to add the required table(s).
9. Start adjusting the speeds!

# License
```
tis-vehspeeds
Copyright (C) 2022 IllusionSquid

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```