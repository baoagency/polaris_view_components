import TextField from './text_field';
export { TextField, };
export function registerPolarisStimulusControllers(application) {
    application.register('text-field', TextField);
}
