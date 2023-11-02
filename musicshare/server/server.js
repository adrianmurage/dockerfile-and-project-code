import express from 'express';
import cors from 'cors';

const app = express();

app.use(cors());

const PORT = '3001';

app.listen(PORT, () => console.log(`Server is listening on PORT ${PORT}`));
