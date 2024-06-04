import fs from 'fs';
import yargs from 'yargs';
import Ajv from 'ajv';

const validate = async (file: string) => {
  if (fs.existsSync(file) === false) {
    console.error(`File not found: ${file}`);
    return;
  }
  const data = JSON.parse(fs.readFileSync(file, 'utf8'));
  
  const schema = {
    type: 'object',
    properties: {
      title: { type: 'string' },
      image: { type: 'string' },
    },
    required: ['title', 'image'],
  };

  // Validate the data
  const ajv = new Ajv();

  const validate = ajv.compile(schema);
  const valid = validate(data);

  if (valid) {
    console.log(`Validation successful: ${file}.`);
  } else {
    console.error(`Validation failed: ${file}.`);
    process.exit(1);
  }
}

(async () => {
  const argv = await yargs(process.argv)
    .alias('f', 'file')
    .argv;

  validate(argv.file as string);
})()