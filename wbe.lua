-- Whole Brain Emulation roadmap, programmatic version

local forecast = require("forecast")
local Tech = forecast.Tech

-- Scientific uncertainties are time-invariant random variables. Technological
-- uncertainties are time-dependent random variables, which may also depend upon
-- scientific uncertainties. Outcomes are deterministic functions of scientific
-- and technoloigcal uncertainties.

-- Relations between technologies are expressed here as one of two types: "any"
-- or "all."

-- An "any" relationship represents a choice between several possible
-- methodologies, where exactly one must be used to satisfy the dependency, and
-- the best can be chosen at any given point.

-- An "all" relationship represents a signal flow or requirement set, all of
-- which must be met and the worst of which becomes a bottleneck or limiting
-- factor.

WBE = Tech:taxonomy {
    Destructive = {
        KESM = {};
        SliceOptical = {
            NSOM = {};
            TIRF = {};
            STED = {};
            SSIM = {};
            LIMON = {};
        };
        SliceEM = {
            _def_Scanning = Tech:taxonomy {
                SBFSEM = {};
                FIBSEM = {};
                ATLUM = {};
            };
            MembraneStain = Tech:process {
                SamplePrep = {};
                Scanning = "inherit";
                Reconstruction = Tech:taxonomy {
                    MachineVision = {};
                    Crowdsourcing = {};
                };
                FunctionFromData = {};
            };
            SelectiveStain = Tech:process {
                SamplePrep = {};
                Scanning = "inherit";
                Reconstruction = Tech:taxonomy {
                    MachineVision = {};
                    Crowdsourcing = {};
                };
                FunctionFromData = {};
            };
        };
        SliceAFM = {};
    };
    Nondestructive = {
        MRI = {};
        TwoPhoton = {};
        XRay = {};
        RFID = {
        };
    };
    GradualReplacement = {};
}

local serpent = require("serpent")
print(serpent.serialize({Tech=Tech,WBE=WBE},{sortkeys=true,comment=false,compact=false,indent='  ',name='_',ignore_keys={__call=true}}))
