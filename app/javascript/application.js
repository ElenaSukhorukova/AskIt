// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap";
import { Turbo } from "@hotwired/turbo-rails";
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
Turbo.session.drive = false;
import "./controllers";

import './scripts/select';

Rails.start();
Turbolinks.start();