#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

// Check for the required arguments
if (process.argv.length !== 4) {
  console.log("Usage: <script> <manifest-path> <output-path>");
  process.exit(1);
}

// Extract paths from command-line arguments
const jsonFilePath = path.resolve(process.argv[2]);
const jsFilePath = path.resolve(process.argv[3]);

fs.readFile(jsonFilePath, "utf8", (err, jsonString) => {
  if (err) {
    console.log("Error reading file:", err);
    return;
  }

  try {
    const data = JSON.parse(jsonString);
    let fileContent = `/* Autogenerated file. Do not edit manually. */\n\n`;
    fileContent += `import { defineComponent, Type as RecsType, World } from "@latticexyz/recs";\n\n`;
    fileContent += `export function defineContractComponents(world: World) {\n  return {\n`;

    data.components.forEach((component) => {
      const tableName = component.name;
      fileContent += `    ${tableName}: (() => {\n`;
      fileContent += `      const name = "${tableName}";\n`;
      fileContent += `      return defineComponent(\n        world,\n        {\n`;

      let types = []

      component.members.filter(m => !m.key).forEach((member) => {
        let memberType = "RecsType.Number";  // Default type set to Number

        if (
          member.type === "bool"
        ) {
          memberType = "RecsType.Boolean";
        // } else if (member.type === "u256") {
        //   memberType = "RecsType.NumberArray";
        // } else if (
        //   ["u8", "u16", "u32", "usize", "u64", "u128", "u250", "felt252", "ContractAddress"].includes(member.type)
        } else if (
          ["u128", "u250", "felt252", "ContractAddress", "u256"].includes(member.type)
        ) {
          memberType = "RecsType.BigInt";
        } else if (
          ["u8", "u16", "u32", "usize", "u64"].includes(member.type)
        ) {
          memberType = "RecsType.Number";
        }

        fileContent += `          ${member.name}: ${memberType},\n`;

        types.push(member.type);
      });

      fileContent += `        },\n        {\n`;
      fileContent += `          metadata: {\n`;
      fileContent += `            name: name,\n`;
      fileContent += `            types: ${JSON.stringify(types)},\n`;
      fileContent += `          },\n        }\n      );\n    })(),\n`;
    });

    fileContent += `  };\n}\n`;

    fs.writeFile(jsFilePath, fileContent, (err) => {
      if (err) {
        console.log("Error writing file:", err);
      } else {
        console.log("File generated successfully");
      }
    });
  } catch (err) {
    console.log("Error parsing JSON string:", err);
  }
});